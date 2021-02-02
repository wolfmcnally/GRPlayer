import GR

class HelloTurtle : Program {
    var turtle: Turtle!
    var startAngle: Double = 0

    override func setup() {
        canvasSize = .init(width: 1920, height: 1080)
        framesPerSecond = 30
        self.turtle = Turtle(canvas: canvas)
    }

    override func update() {
        startAngle += 360° * 0.001
    }

    override func draw()  {
        let steps = 36
        let angleStep = 360° / Double(steps)
        let hueStep = 1 / Double(steps)
        let sides = 30
        let sideStep = 360° / Double(sides)
        turtle.angle = startAngle
        for step in 0..<steps {
            turtle.penColor = Color(hue: Double(step) * hueStep, saturation: 1, brightness: 1)
            for _ in 1...sides {
                turtle.forward(50)
                turtle.right(sideStep)
            }
            turtle.right(angleStep)
        }
    }

}

final class Turtle {
    let canvas: Canvas
    var position: Point
    var angle: Double // radians
    var penColor: Color = .white
    var isPenDown: Bool = true

    init(canvas: Canvas, angle: Double = 0) {
        self.canvas = canvas
        self.position = canvas.bounds.midXmidY.snapped
        self.angle = angle
    }

    func forward(_ distance: Double) {
        let oldPosition = position
        position += Polar(magnitude: distance, angle: angle)
        canvas.drawLine(from: oldPosition, to: position, color: penColor, lineCap: .round)
    }

    func right(_ angle: Double) {
        self.angle += angle
    }
}
