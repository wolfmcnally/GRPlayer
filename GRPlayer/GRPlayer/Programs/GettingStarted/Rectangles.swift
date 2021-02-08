import GR

class Rectangles: Program {
    override func draw()  {
        canvas.drawRectangle(IntRect(x: 5, y: 5, width: 5, height: 5), color: .red)
        canvas.drawRectangle(IntRect(x: 21, y: 3, width: 8, height: 2), color: .white)
        canvas.drawRectangle(IntRect(x: 29, y: 5, width: 5, height: 6), color: .yellow)
        canvas.drawRectangle(IntRect(x: 16, y: 5, width: 9, height: 11), color: .purple)
        canvas.drawRectangle(IntRect(x: 22, y: 14, width: 9, height: 8), color: .mediumBlue)
        canvas.drawRectangle(IntRect(x: 16, y: 20, width: 9, height: 8), color: .orange)
        canvas.drawRectangle(IntRect(x: 23, y: 26, width: 7, height: 4), color: .lightGray)
        canvas.drawRectangle(IntRect(x: 29, y: 19, width: 6, height: 5), color: .green)
    }
}

extension Canvas {
    func drawRectangle(_ rect: IntRect, color: Color) {
        drawHorizontalLine(in: rect.rangeX, at: rect.minY, color: color)
        drawHorizontalLine(in: rect.rangeX, at: rect.maxY, color: color)
        drawVerticalLine(in: rect.rangeY, at: rect.minX, color: color)
        drawVerticalLine(in: rect.rangeY, at: rect.maxX, color: color)
    }
}
