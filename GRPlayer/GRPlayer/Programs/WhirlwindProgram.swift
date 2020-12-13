import Foundation
import GR
import Interpolate

class WhirlwindProgram: Program {
    private struct Particle {
        var center: Point = .zero
        var radius: Double = 0
        var angle: Double = 0
        var angularSpeed: Double = 0
        var color: Color = .white
    }

    private let particlesCount = 2000
    private var particles = [Particle]()
    private var center = Point.zero

    override func setup() {
        framesPerSecond = 60
        canvasSize = Size(width: 100, height: 150)
        backgroundCanvas.clearColor = .clear
        center = canvas.bounds.midXmidY
        for _ in 0 ..< particlesCount {
            particles.append(makeParticle())
        }
    }

    override func update() {
        particles = particles.map {
            var p = $0
            p.angle += p.angularSpeed
            return p
        }
        // Inefficient due to copy-on-write
        //    for i in 0 ..< particles.count {
        //        particles[i].angle += particles[i].angularSpeed
        //    }
    }

    override func draw() {
        let bounds = canvas.bounds.intView
        for p in particles {
            let x = Int(p.center.x + cos(p.angle) * p.radius + 0.5)
            let y = Int(p.center.y + sin(p.angle) * p.radius + 0.5)
            let point = Point(x: x, y: y)
            guard bounds.isValidPoint(point) else { continue }
            canvas[point] = p.color
        }
    }

    private func makeParticle() -> Particle {
        var p = Particle()

        p.center = canvas.bounds.midXmidY

        let minRadius = Double(canvas.bounds.maxX) / 15
        let r = Double(canvas.bounds.midY)
        let maxRadius = sqrt(r * r  +  r * r)
        p.radius = .random(in: minRadius ... maxRadius)

        p.angle = .random(in: 0 ... (2 * .pi))

        let minSteps = 400.0
        let maxSteps = 600.0
        p.angularSpeed = .pi * 2 / .random(in: minSteps ... maxSteps)

        let minSpeed = 1.0
        let maxSpeed = 4.0
        p.angularSpeed *= p.radius.interpolate(from: (minRadius, maxRadius), to: (maxSpeed, minSpeed))

        let minAngSpeed = .pi * 2 / maxSteps * minSpeed
        let maxAngSpeed = .pi * 2 / minSteps * maxSpeed

        let baseHue = 0°
        let hueOffset = 40°
        let hue: Frac
        switch Bool.random() {
        case false:
            hue = baseHue / 360°
        case true:
            hue = (baseHue + hueOffset) / 360°
        }
        let saturation = Double.random(in: 0.8 ... 1.0)
        let minBrightness = 0.2
        let maxBrightness = 1.0
        let brightness = Easing.easeIn.apply(p.angularSpeed.interpolate(from: (maxAngSpeed, minAngSpeed), to: (minBrightness, maxBrightness)))

        p.color = Color(hue: hue, saturation: saturation, brightness: brightness)

        return p
    }
}
