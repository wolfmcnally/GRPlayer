import GR

class MandalaProgram: Program {
    var i = 0
    var color: Color = .black

    override func setup() {
        framesPerSecond = 20
        canvas.clearColor = .clear
        i = -1
    }

    override func update() {
        i += 1

        if i == canvas.bounds.intView.maxX {
            i = 0
        }

        color = Color.random()
    }

    override func draw() {
        let bounds = canvas.bounds.intView
        canvas.drawHorizontalLine(in: bounds.rangeX, at: i, color: color)
        canvas.drawHorizontalLine(in: bounds.rangeX, at: bounds.maxY - i, color: color)
        canvas.drawVerticalLine(in: bounds.rangeY, at: i, color: color)
        canvas.drawVerticalLine(in: bounds.rangeY, at: bounds.maxX - i, color: color)
    }
}
