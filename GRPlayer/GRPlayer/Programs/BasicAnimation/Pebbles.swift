import GR

class Pebbles: Program {
    override func draw() {
        for _ in 1...50 {
            let p = canvas.bounds.intView.randomPoint()
            let c = Color.random()
            canvas[p] = c
        }
    }
}
