import GR

class GravelProgram : Program {
    
    override func setup() {
        framesPerSecond = 30
        canvasSize = Size(width: 100, height: 100)
    }
    
    override func draw()  {
        for _ in 1...100 {
            canvas[canvas.bounds.intView.randomPoint()] = .random()
        }
    }
    
}
