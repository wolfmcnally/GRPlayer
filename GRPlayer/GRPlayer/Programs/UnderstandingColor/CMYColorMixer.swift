import GR
import Interpolate

class CMYColorMixer: Program {
    var sliders: [Slider] = []
    var cyan: Frac = 0
    var magenta: Frac = 0
    var yellow: Frac = 0
    var touchedSlider: Slider?
    
    override func setup() {
        canvasSize = [200, 300]
        canvas.clearColor = .white
        
        cyan = 0
        magenta = 0
        yellow = 0
        
        let sliderMinY = 210
        let sliderSpacing = 30
        
        let cyanSlider = Slider(canvas: canvas, y: sliderMinY, color: .cyan, value: cyan) { [unowned self] value in
            self.cyan = value
            self.display()
        }

        let magentaSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing, color: .magenta, value: magenta) { [unowned self] value in
            self.magenta = value
            self.display()
        }

        let yellowSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing * 2, color: .yellow, value: yellow) { [unowned self] value in
            self.yellow = value
            self.display()
        }
        
        sliders = [cyanSlider, magentaSlider, yellowSlider]
    }
    
    override func draw() {
        let circleRadius = 50.0
        let offsetMagnitude = 30.0
        let center: Point = [100, 120]
        let angleOffset = -90°
        
        let cyanCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 0° + angleOffset))
        let magentaCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 120° + angleOffset))
        let yellowCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 240° + angleOffset))

        canvas.fill(path: cyanCircle, color: Color(red: cyan, green: 0, blue: 0), blendMode: .difference)
        canvas.fill(path: magentaCircle, color: Color(red: 0, green: magenta, blue: 0), blendMode: .difference)
        canvas.fill(path: yellowCircle, color: Color(red: 0, green: 0, blue: yellow), blendMode: .difference)

        for slider in sliders {
            slider.draw()
        }
        
        let swatchRadius = 10.0
        let swatchCenter = (Rect(canvas.bounds).midXminY + Vector(dx: 0, dy: swatchRadius + 5)).snapped
        let swatch = Path(circleCenter: swatchCenter, radius: swatchRadius)
        canvas.fill(path: swatch, color: Color(red: cyan, green: magenta, blue: yellow), blendMode: .difference)
        canvas.stroke(path: swatch, color: .white)
    }
    
    private func makeCircle(center: Point, radius: Double, offset: Polar) -> Path {
        return Path(circleCenter: center + offset, radius: radius)
    }
    
    class Slider {
        let canvas: Canvas
        let y: Int
        let color: Color
        var value: Frac {
            didSet {
                valueChanged(value)
            }
        }
        let valueChanged: (Frac) -> Void
        
        let thumbWidth = 10.0
        let barThickness = 6.0
        
        let frame: Rect
        let barFrame: Rect

        init(canvas: Canvas, y: Int, color: Color, value: Frac = 1, valueChanged: @escaping (Frac) -> Void) {
            self.canvas = canvas
            self.y = y
            self.color = color
            self.value = value
            self.valueChanged = valueChanged

            let canvasBounds = Rect(canvas.bounds)
            self.frame = Rect(x: canvasBounds.minX + 10, y: Double(y), width: canvasBounds.maxX - 20, height: 20.0)
            self.barFrame = Rect(origin: frame.midXmidY, size: .zero).inset(dx: -(frame.width - thumbWidth) / 2, dy: -barThickness / 2)
        }
        
        var thumbFrame: Rect {
            let minX = frame.minX + thumbWidth / 2
            let maxX = frame.maxX - thumbWidth / 2
            let x = minX.interpolate(to: maxX, at: value)
            return Rect(origin: Point(x: x, y: frame.midY), size: .zero).inset(dx: -thumbWidth / 2, dy: -frame.height / 2)
        }
        
        func draw() {
            let gradient = Gradient(color.withAlphaComponent(0), color)
            canvas.fill(path: Path(rect: barFrame), linearGradient: gradient, start: barFrame.minXmidY, end: barFrame.maxXmidY)
            canvas.fill(path: Path(rect: thumbFrame), color: .init(white: 0, alpha: 0.5))
        }
        
        func touched(at point: Point) {
            guard frame.inset(dx: 0, dy: -50).contains(point) else { return }

            let minX = frame.minX + thumbWidth / 2
            let maxX = frame.maxX - thumbWidth / 2
            value = point.x.interpolate(from: (minX, maxX)).clamped
        }
    }
    
    override func onEvent(event: Event) {
        switch event {
        case .touchBegan(let point):
            touchedSlider = findTouchedSlider(point: point)
            touchedSlider?.touched(at: point)
        case .touchMoved(let point):
            touchedSlider?.touched(at: point)
        case .touchEnded:
            touchedSlider = nil
        default:
            break
        }
    }
    
    func findTouchedSlider(point: Point) -> Slider? {
        sliders.first { $0.frame.contains(point) }
    }
}
