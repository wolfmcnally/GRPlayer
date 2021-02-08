import GR

class MoreStix: Program {
    override func setup() {
        framesPerSecond = 30
        canvasSize = [1920 / 4, 1080 / 4]
    }

    override func draw() {
        let bounds = Rect(canvas.bounds)
        for _ in 1...20 {
            canvas.drawLine(from: bounds.randomPoint(), to: bounds.randomPoint(), color: Color.random())
        }
    }
}
