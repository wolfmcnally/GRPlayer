import GR
import Interpolate

class HSBColorMixer: Program {
    var sliders: [Slider] = []
    var hue: Angle = 0°
    var saturation: Frac = 0
    var brightness: Frac = 0
    var touchedSlider: Slider?

    override func setup() {
        canvasSize = [200, 300]
        canvas.clearColor = .black
        
        hue = 0°
        saturation = 1
        brightness = 1
        
        let sliderMinY = 210
        let sliderSpacing = 30
        
        let hueSlider = Slider(canvas: canvas, y: sliderMinY, value: hue.unit) { [unowned self] value in
            self.hue = Angle(unit: value)
            self.display()
        } barColor: { t in
            Color(HSBColor(hue: Angle(unit: t), saturation: 1, brightness: 1))
        }

        let saturationSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing, value: saturation) { [unowned self] value in
            self.saturation = value
            self.display()
        } barColor: { t in
            Color(HSBColor(hue: self.hue, saturation: t, brightness: 1))
        }

        let brightnessSlider = Slider(canvas: canvas, y: sliderMinY + sliderSpacing * 2, value: brightness) { [unowned self] value in
            self.brightness = value
            self.display()
        } barColor: { t in
            Color(HSBColor(hue: self.hue, saturation: 1, brightness: t))
        }

        sliders = [hueSlider, saturationSlider, brightnessSlider]
    }
    
    override func draw() {
        let radius = 80.0
        let center: Point = [100, 120]
        
        for dy in stride(from: -radius, through: radius, by: 1) {
            for dx in stride(from: -radius, through: radius, by: 1) {
                let v = Vector(dx: dx, dy: dy)
                let p = center + v
                let saturation = v.magnitude / radius
                if saturation <= 1 {
                    let alpha: Double
                    let edgeR = 1 - (1 / radius)
                    if saturation < edgeR {
                        alpha = 1
                    } else {
                        alpha = saturation.interpolate(from: (1, edgeR))
                    }
                    let color: HSBColor
                    if saturation > 0 {
                        let hue = v.normalized.angle
                        color = HSBColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
                    } else {
                        color = HSBColor(brightness: brightness, alpha: alpha)
                    }
                    canvas[p] = Color(color)
                }
            }
        }

        for slider in sliders {
            slider.draw()
        }

        let focusCenter = center + Polar(magnitude: saturation * radius, angle: hue)
        let focus1 = Path(circleCenter: focusCenter, radius: 5)
        canvas.stroke(path: focus1, color: .black)
        let focus2 = Path(circleCenter: focusCenter, radius: 6)
        canvas.stroke(path: focus2, color: .white)

        let swatchRadius = 10.0
        let swatchCenter = (Rect(canvas.bounds).midXminY + Vector(dx: 0, dy: swatchRadius + 5)).snapped
        let swatch = Path(circleCenter: swatchCenter, radius: swatchRadius)
        let color = Color(HSBColor(hue: hue, saturation: saturation, brightness: brightness))
        canvas.fill(path: swatch, color: color)
        canvas.stroke(path: swatch, color: .white)
    }
    
    class Slider {
        let canvas: Canvas
        let y: Int
        let barColor: (Frac) -> Color
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

        init(canvas: Canvas, y: Int, value: Frac = 1, valueChanged: @escaping (Frac) -> Void, barColor: @escaping (Frac) -> Color) {
            self.canvas = canvas
            self.y = y
            self.value = value
            self.valueChanged = valueChanged
            self.barColor = barColor

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
            for x in stride(from: barFrame.minX, to: barFrame.maxX, by: 1) {
                let t = x.interpolate(from: (barFrame.minX, barFrame.maxX))
                let color = barColor(t)
                for y in stride(from: barFrame.minY, to: barFrame.maxY, by: 1) {
                    canvas[x, y] = color
                }
            }
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
