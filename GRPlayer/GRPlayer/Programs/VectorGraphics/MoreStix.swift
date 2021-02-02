import GR

class MoreStix: Program {
    override func setup() {
        framesPerSecond = 30
        canvasSize = Size(width: 1920 / 4, height: 1080 / 4)
    }

    override func draw() {
        let bounds = canvas.bounds
        for _ in 1...20 {
            canvas.drawLine(from: bounds.randomPoint(), to: bounds.randomPoint(), color: Color.random())
        }
    }
}
