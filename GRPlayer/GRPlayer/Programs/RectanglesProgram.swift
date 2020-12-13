import GR

class RectanglesProgram: Program {
    
    override func draw()  {
        drawRectangle(Rect(x: 5, y: 5, width: 5, height: 5), color: .red)
        drawRectangle(Rect(x: 21, y: 3, width: 8, height: 2), color: .white)
        drawRectangle(Rect(x: 29, y: 5, width: 5, height: 6), color: .yellow)
        drawRectangle(Rect(x: 16, y: 5, width: 9, height: 11), color: .purple)
        drawRectangle(Rect(x: 22, y: 14, width: 9, height: 8), color: .mediumBlue)
        drawRectangle(Rect(x: 16, y: 20, width: 9, height: 8), color: .orange)
        drawRectangle(Rect(x: 23, y: 26, width: 7, height: 4), color: .lightGray)
        drawRectangle(Rect(x: 29, y: 19, width: 6, height: 5), color: .green)
    }

    func drawRectangle(_ rect: Rect, color: Color) {
        let r = rect.intView
        canvas.drawHorizontalLine(in: r.rangeX, at: r.minY, color: color)
        canvas.drawHorizontalLine(in: r.rangeX, at: r.maxY, color: color)
        canvas.drawVerticalLine(in: r.rangeY, at: r.minX, color: color)
        canvas.drawVerticalLine(in: r.rangeY, at: r.maxX, color: color)
    }    
}
