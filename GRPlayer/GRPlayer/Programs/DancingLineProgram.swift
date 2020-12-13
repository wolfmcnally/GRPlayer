import GR
import Interpolate

class DancingLineProgram: Program {
    var lines: [Line] = []

    override func setup() {
        framesPerSecond = 30
        let divisor = 2
        canvasSize = Size(width: 1920 / divisor, height: 1080 / divisor)

        for _ in 1...5 {
            lines.append(Line(bounds: canvas.bounds, maxHistoryCount: 20))
        }

        backgroundCanvas.clearColor = .black
    }

    override func update() {
        lines.forEach { line in
            line.update(bounds: canvas.bounds)
        }
    }

    override func draw() {
        lines.forEach { line in
            line.draw(canvas)
        }
    }
}

final class LineEnd {
    var p: Point
    var v: Vector

    init(bounds: Rect) {
        p = bounds.randomPoint()
        v = Vector(dx: Self.randomOffset(), dy: Self.randomOffset())
    }

    private static func randomPositiveOffset() -> Double {
        Double.random(in: 3 ... 6)
    }

    private static func randomOffset() -> Double {
        Bool.random() ? randomPositiveOffset() : -randomPositiveOffset()
    }

    private func updateAxis(bounds: ClosedRange<Double>, p: inout Double, v: inout Double) {
        var newV = v
        if p + newV > bounds.upperBound {
            newV = -Self.randomPositiveOffset()
        }
        if p + newV < bounds.lowerBound {
            newV = Self.randomPositiveOffset()
        }

        p = p + newV
        v = newV
    }

    func update(bounds: Rect) {
        updateAxis(bounds: bounds.rangeX, p: &p.x, v: &v.dx)
        updateAxis(bounds: bounds.rangeY, p: &p.y, v: &v.dy)
    }
}

struct HistoryLine {
    let p1: Point
    let p2: Point
}

final class Line {
    let maxHistoryCount: Int
    let e1: LineEnd
    let e2: LineEnd
    let color: Color

    var history: [HistoryLine] = []
    let historyColors: [Color]

    init(bounds: Rect, maxHistoryCount: Int) {
        self.maxHistoryCount = maxHistoryCount
        self.e1 = LineEnd(bounds: bounds)
        self.e2 = LineEnd(bounds: bounds)
        let color = Color.random()
        self.color = color

        let step = 1.0 / Double(maxHistoryCount)
        self.historyColors = stride(from: 0.0, to: 1.0, by: step).map { t in
            color.interpolate(to: Color.clear, at: t)
        }
        assert(historyColors.count == maxHistoryCount)
    }

    func update(bounds: Rect) {
        if history.count == maxHistoryCount {
            history.removeLast()
        }
        e1.update(bounds: bounds)
        e2.update(bounds: bounds)
        history.insert(.init(p1: e1.p, p2: e2.p), at: 0)
    }

    func draw(_ canvas: Canvas) {
        zip(history, historyColors).forEach { (line, color) in
            canvas.drawLine(from: line.p1, to: line.p2, color: color)
        }
    }
}
