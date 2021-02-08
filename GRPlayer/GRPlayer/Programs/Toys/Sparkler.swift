import GR
import Interpolate

class Sparkler: Program {
    let numSparks = 400
    let gravity = 0.05
    var frame = 0;
    var genPosition = IntPoint.zero
    var genHue: Frac = 0

    struct Spark {
        var position: Point
        var direction: Vector
        var hue: Frac
        var saturation: Frac
        let bornFrame: Int
        let dieFrame: Int
    }

    var sparks = [Spark]()

    override func setup() {
        canvasSize = [150, 250]
        framesPerSecond = 60
        backgroundCanvas.clearColor = .black
        for _ in 0 ..< numSparks {
            sparks.append(makeSpark())
        }
    }

    override func update() {
        frame += 1

        sparks = sparks.map {
            guard frame < $0.dieFrame else {
                return makeSpark()
            }
            var spark = $0
            spark.direction.dy += gravity
            spark.position += spark.direction
            return spark
        }
    }

    override func draw() {
        let bounds = canvas.bounds
        for spark in sparks {
            let p = IntPoint(spark.position)
            guard bounds.isValidPoint(p) else { continue }

            let percentLived = (Double(spark.bornFrame) .<. Double(spark.dieFrame))(Double(frame))

            let bri: Frac
            let sat: Frac
            if percentLived < 0.9 {
                sat = spark.saturation
                bri = (1.0 .>. 0.2)(percentLived)
            } else {
                sat = 0
                bri = percentLived.interpolate(from: (0.9, 1.0), to: (1.0, 0.0))
            }

            let color = Color(HSBColor(hue: spark.hue, saturation: sat, brightness: bri))
            canvas[spark.position] = color
        }
    }

    override func onEvent(event: Event) {
        switch event {
        case .touchBegan(let point):
            genPosition = canvas.bounds.clampPoint(IntPoint(point))
            genHue = Double.randomFrac()
        case .touchMoved(let point):
            genPosition = canvas.bounds.clampPoint(IntPoint(point))
        default:
            break
        }
    }

    private func makeSpark() -> Spark {
        let framesToLive = Int.random(in: 20 ... 50)
        let bornFrame = frame
        let dieFrame = bornFrame + framesToLive

        let position = Point(genPosition)
        let angle = Double.random(in: 0.0 ... Double.pi * 2)
        let speed = Double.random(in: 0.5 ... 2.0)
        let direction = Vector(angle: angle, magnitude: speed)

        let hue: Frac
        let saturation: Frac
        switch Int.random(in: 0 ... 2) {
        case 0:
            hue = genHue + 200.0 / 360.0
            saturation = 1
        case 1:
            hue = 0
            saturation = 0
        case 2:
            hue = genHue + 180.0 / 360.0
            saturation = 0.8
        default:
            fatalError()
        }

        return Spark(position: position, direction: direction, hue: hue, saturation: saturation, bornFrame: bornFrame, dieFrame: dieFrame)
    }
}
