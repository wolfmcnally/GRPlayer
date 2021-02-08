import GR

class Gravel : Program {
    override func setup() {
        framesPerSecond = 30
        canvasSize = [100, 100]
    }
    
    override func draw()  {
        for _ in 1...100 {
            canvas[canvas.bounds.randomPoint()] = .random()
        }
    }
}
