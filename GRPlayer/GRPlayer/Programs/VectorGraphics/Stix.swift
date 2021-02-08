import GR

class Stix: Program {
    override func setup() {
        canvasSize = [1920 / 4, 1080 / 4]
    }

    override func draw() {
        let bounds = Rect(canvas.bounds)
        for _ in 1...50 {
            let p1 = bounds.randomPoint()
            let p2 = bounds.randomPoint()
            let c = Color.random()
            canvas.drawLine(from: p1, to: p2, color: c)
        }
    }
}
