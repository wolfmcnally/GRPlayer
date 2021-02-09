import GR

class HelloTurtle : Program {
    var turtle: Turtle!
    var startAngle: Angle = .zero

    override func setup() {
        canvasSize = [1920, 1080]
        framesPerSecond = 30
        self.turtle = Turtle(canvas: canvas)
    }

    override func update() {
        startAngle += 360° * 0.001
    }

    override func draw()  {
        let steps = 36
        let angleStep = 360° / Double(steps)
        let hueStep = 360° / Double(steps)
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
    var angle: Angle
    var penColor: Color = .white
    var isPenDown: Bool = true

    init(canvas: Canvas, angle: Angle = .zero) {
        self.canvas = canvas
        self.position = Rect(canvas.bounds).midXmidY
        self.angle = angle
    }

    func forward(_ distance: Double) {
        let oldPosition = position
        position += Polar(magnitude: distance, angle: angle)
        canvas.drawLine(from: oldPosition, to: position, color: penColor, lineCap: .round)
    }

    func right(_ angle: Angle) {
        self.angle += angle
    }
}
