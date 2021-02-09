import GR

class HelloPath : Program {
    override func setup() {
        canvasSize = [200, 200]
    }

    override func draw() {
        let path: Path = [
            .moveTo([0, 0]),
            .addLine([50, 50]),
            .addLine([50, 100]),
            .addLine([10, 30]),
            .close
        ]

        canvas.stroke(path: path, color: .red)
    }
}
