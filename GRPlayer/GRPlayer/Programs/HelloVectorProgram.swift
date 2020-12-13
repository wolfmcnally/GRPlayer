import GR

class HelloVectorProgram : Program {

    override func draw()  {
        let p1 = Point(x: 0, y: 0)
        let p2 = Point(x: 30, y: 18)
        let c = Color.red
        canvas.drawLine(from: p1, to: p2, color: c)
    }

}
