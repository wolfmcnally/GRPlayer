import GR

class HelloCorners: Program {
    override class var subtitle: String? { "Reaching the Limits" }

    override func draw()  {
        let bounds = canvas.bounds

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
