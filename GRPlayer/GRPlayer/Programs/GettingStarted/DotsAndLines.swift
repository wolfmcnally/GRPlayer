import GR

class DotsAndLines: Program {
    override func draw()  {
        func drawHorizontalLine(x1: Int, x2: Int, y: Int, color: Color) {
            for x in x1...x2 {
                canvas[x, y] = color
            }
        }
        
        func drawVerticalLine(y1: Int, y2: Int, x: Int, color: Color) {
            for y in y1...y2 {
                canvas[x, y] = color
            }
        }

        canvas[20, 15] = .gold
        canvas[10, 29] = .blueGreen
        canvas[5, 17] = .green
        canvas[14, 10] = .purple
        canvas[22, 9] = .red
        
        drawHorizontalLine(x1: 10, x2: 20, y: 3, color: .white)
        drawHorizontalLine(x1: 30, x2: 39, y: 25, color: .red)
        drawHorizontalLine(x1: 15, x2: 18, y: 3, color: .purple)
        drawHorizontalLine(x1: 2, x2: 39, y: 30, color: .random())
        drawHorizontalLine(x1: 5, x2: 33, y: 30, color: .orange)
        drawHorizontalLine(x1: 1, x2: 38, y: 1, color: .purple)
        
        drawVerticalLine(y1: 1, y2: 22, x: 37, color: .random())
        drawVerticalLine(y1: 1, y2: 5, x: 7, color: .yellow)

        canvas[37, 13] = .brown
        
        drawVerticalLine(y1: 3, y2: 21, x: 27, color: .magenta)
        drawVerticalLine(y1: 2, y2: 10, x: 27, color: .darkGreen)
        drawVerticalLine(y1: 5, y2: 30, x: 1, color: .deepBlue)
        drawVerticalLine(y1: 0, y2: 4, x: 1, color: .white)
    }
}
