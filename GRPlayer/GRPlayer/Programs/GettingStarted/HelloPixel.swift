import GR

class HelloPixel: Program {
    override class var title: String { "Hello Pixel!" }
    override class var subtitle: String? { "Isn't it cute?" }

    override func draw()  {
        canvas[0, 0] = .red
    }
}
