import GR

class Rectangles: Program {
    override func draw()  {
        canvas.drawRectangle(Rect(x: 5, y: 5, width: 5, height: 5), color: .red)
        canvas.drawRectangle(Rect(x: 21, y: 3, width: 8, height: 2), color: .white)
        canvas.drawRectangle(Rect(x: 29, y: 5, width: 5, height: 6), color: .yellow)
        canvas.drawRectangle(Rect(x: 16, y: 5, width: 9, height: 11), color: .purple)
        canvas.drawRectangle(Rect(x: 22, y: 14, width: 9, height: 8), color: .mediumBlue)
        canvas.drawRectangle(Rect(x: 16, y: 20, width: 9, height: 8), color: .orange)
        canvas.drawRectangle(Rect(x: 23, y: 26, width: 7, height: 4), color: .lightGray)
        canvas.drawRectangle(Rect(x: 29, y: 19, width: 6, height: 5), color: .green)
    }
}

extension Canvas {
    func drawRectangle(_ rect: Rect, color: Color) {
        let r = rect.intView
        drawHorizontalLine(in: r.rangeX, at: r.minY, color: color)
        drawHorizontalLine(in: r.rangeX, at: r.maxY, color: color)
        drawVerticalLine(in: r.rangeY, at: r.minX, color: color)
        drawVerticalLine(in: r.rangeY, at: r.maxX, color: color)
    }
}
