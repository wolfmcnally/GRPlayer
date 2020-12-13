import GR

class HelloCornersProgram : Program {

    override func draw()  {
        let bounds = canvas.bounds.intView

        for x in bounds.minX ... bounds.maxX {
            let y = x
            canvas[x, y] = .red
        }

        for y in bounds.minY ... bounds.maxY {
            let x = bounds.maxY - y
            canvas[x, y] = .blue
        }
    }

}
