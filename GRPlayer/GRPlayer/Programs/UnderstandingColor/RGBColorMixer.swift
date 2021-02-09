import GR
import Interpolate

class RGBColorMixer: Program {
    var sliders: [Slider] = []
    var red: Frac = 0
    var green: Frac = 0
    var blue: Frac = 0
    var touchedSlider: Slider?
    
    override func setup() {
        canvasSize = [200, 300]
        canvas.clearColor = .black
        
        red = 0
        green = 0
        blue = 0
        
        let sliderMinY = 210
        let sliderSpacing = 30
        
        let redSlider = Slider(canvas: canvas, y: sliderMinY, color: .red, value: red) { [unowned self] value in
            self.red = value
            self.display()
        }

        let greenSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing, color: .green, value: green) { [unowned self] value in
            self.green = value
            self.display()
        }

        let blueSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing * 2, color: .blue, value: blue) { [unowned self] value in
            self.blue = value
            self.display()
        }
        
        sliders = [redSlider, greenSlider, blueSlider]
    }
    
    override func draw() {
        let circleRadius = 50.0
        let offsetMagnitude = 30.0
        let center: Point = [100, 120]
        let angleOffset = -90°
        
        let redCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 0° + angleOffset))
        let greenCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 120° + angleOffset))
        let blueCircle = makeCircle(center: center, radius: circleRadius, offset: Polar(magnitude: offsetMagnitude, angle: 240° + angleOffset))
        canvas.fill(path: redCircle, color: Color(red: red, green: 0, blue: 0), blendMode: .plusLighter)
        canvas.fill(path: greenCircle, color: Color(red: 0, green: green, blue: 0), blendMode: .plusLighter)
        canvas.fill(path: blueCircle, color: Color(red: 0, green: 0, blue: blue), blendMode: .plusLighter)
        
        for slider in sliders {
            slider.draw()
        }
        
        let swatchRadius = 10.0
        let swatchCenter = (Rect(canvas.bounds).midXminY + Vector(dx: 0, dy: swatchRadius + 5)).snapped
        let swatch = Path(circleCenter: swatchCenter, radius: swatchRadius)
        canvas.fill(path: swatch, color: Color(red: red, green: green, blue: blue))
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
            canvas.fill(path: Path(rect: thumbFrame), color: .init(white: 1, alpha: 0.5))
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
