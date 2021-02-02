import GR
import Interpolate

class RainingHearts: Program {
    let heartsCount = 50
    let minSpeed = 0.6
    let maxSpeed = 1.9

    var hearts = [MySprite]()

    override func setup() {
        canvasSize = Size(width: 200, height: 200)
        framesPerSecond = 30

        for _ in 0 ..< heartsCount {
            let index = allShapes.randomIndex()!
            let shape = allShapes[index]
            let sprite = MySprite(shape: shape)

            sprite.position = canvas.bounds.intView.randomPoint()

            var dirX = Double(index).interpolate(from: (0, Double(allShapes.count) - 1), to: (minSpeed, maxSpeed))
            dirX += Double.random(in: 0 ... 2)
            sprite.direction = Vector(dx: -dirX / 2, dy: dirX)

            let saturation = Double.random(in: 0.8 ... 1.0)
            let minBrightness = 0.5
            let maxBrightness = 1.0
            let brightness = Double(index).interpolate(from: (0, Double(allShapes.count) - 1), to: (minBrightness, maxBrightness))
            let hue: Double
            let colorPicker = Double.randomFrac()
            switch colorPicker {
            case ..<0.48:
                // shade of purple-red heart
                hue = Double.random(in: (290.0 / 360.0) ... (310.0 / 360.0))
            case ..<0.96:
                // shade of blue heart
                hue = Double.random(in: 0.56 ... 0.58)
            default:
                // pure red heart
                hue = 0
            }
            let color = Color(HSBColor(hue: hue, saturation: saturation, brightness: brightness))
            sprite.shape.colors["❤️"] = color

            sprite.z = brightness

            hearts.append(sprite)
        }

        hearts.sort { $0.z < $1.z }
    }

    override func update() {
        for heart in hearts {
            heart.position += heart.direction
        }
    }

    override func draw() {
        for heart in hearts {
            heart.draw(into: canvas)
        }
    }

    class MySprite: SimpleSprite {
        var direction: Vector = .zero
        var z: Double = 0

        init(shape: Shape) {
            super.init(shape: shape, mode: .wrap)
        }
    }

    let smallHeart = Shape(
        offset: Vector(dx: 2, dy: 1).intView,
        rows: [
            "❔❤️❔❤️❔",
            "❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❔",
            "❔❔❤️❔❔"
        ]
    )

    let mediumHeart = Shape(
        offset: Vector(dx: 4, dy: 3).intView,
        rows: [
            "❔❤️❤️❔❔❔❤️❤️❔",
            "❤️❤️❤️❤️❔❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❔❔❔❔"
        ]
    )

    let largeHeart = Shape(
        offset: Vector(dx: 6, dy: 4).intView,
        rows: [
            "❔❔❤️❤️❤️❔❔❔❤️❤️❤️❔❔",
            "❔❤️❤️❤️❤️❤️❔❤️❤️❤️❤️❤️❔",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❤️❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❤️❤️❤️❤️❔❔❔❔",
            "❔❔❔❔❔❤️❤️❤️❔❔❔❔❔",
            "❔❔❔❔❔❔❤️❔❔❔❔❔❔"
        ]
    )

    let xLargeHeart = Shape(
        offset: Vector(dx: 8, dy: 6).intView,
        rows: [
            "❔❔❔❤️❤️❤️❤️❔❔❔❤️❤️❤️❤️❔❔❔",
            "❔❔❤️❤️❤️❤️❤️❤️❔❤️❤️❤️❤️❤️❤️❔❔",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️",
            "❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔",
            "❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔",
            "❔❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔❔",
            "❔❔❔❔❤️❤️❤️❤️❤️❤️❤️❤️❤️❔❔❔❔",
            "❔❔❔❔❔❤️❤️❤️❤️❤️❤️❤️❔❔❔❔❔",
            "❔❔❔❔❔❔❤️❤️❤️❤️❤️❔❔❔❔❔❔",
            "❔❔❔❔❔❔❔❤️❤️❤️❔❔❔❔❔❔❔",
            "❔❔❔❔❔❔❔❔❤️❔❔❔❔❔❔❔❔"
        ]
    )

    private lazy var allShapes: [Shape] = [
        smallHeart,
        mediumHeart,
        largeHeart,
        xLargeHeart
    ]
}

