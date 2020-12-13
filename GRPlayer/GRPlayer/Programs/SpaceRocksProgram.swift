import GR

class SpaceRocksProgram : Program {
    let player = Player()
    let saucer = Saucer()
    var rocks: [Rock] = []

    override func setup() {
        canvasSize = [1280, 960]
        backgroundCanvas.clearColor = .black
        framesPerSecond = 30

        player.position = canvas.bounds.midXmidY
        saucer.position = [50, 50]

        for _ in 0..<20 {
            let position = canvas.bounds.randomPoint()
            let rotation = Double.random(in: 0 ..< 360°)
            let index = Int.random(in: 0..<4)
            let heft = Rock.Heft.allCases.randomChoice()
            rocks.append(Rock(position: position, rotation: rotation, index: index, heft: heft))
        }
    }

    override func update() {
        for rock in rocks {
            rock.update(in: canvas)
        }

        player.update(in: canvas)
        saucer.update(in: canvas)
    }

    override func draw() {
        for rock in rocks {
            rock.draw(in: canvas)
        }

        player.draw(in: canvas)
        saucer.draw(in: canvas)
    }
}

struct PathShape {
    var path: Path
    var color: Color
    var lineWidth: Double = 1
}

class Sprite {
    var position: Point
    var speed: Vector
    let pathShapes: [PathShape]
    var scale: Double
    var rotation: Double

    init(position: Point, speed: Vector, rotation: Double, scale: Double, pathShapes: [PathShape]) {
        self.position = position
        self.speed = speed
        self.rotation = rotation
        self.scale = scale
        self.pathShapes = pathShapes
    }

    func update(in canvas: Canvas) {
        position += speed
        let bounds = canvas.bounds
        position.x = (position.x + bounds.width).truncatingRemainder(dividingBy: bounds.width)
        position.y = (position.y + bounds.height).truncatingRemainder(dividingBy: bounds.height)
    }

    func draw(in canvas: Canvas) {
        for shape in pathShapes {
            let p = shape.path.scaled(by: scale).rotated(by: rotation).translated(by: position)
            canvas.draw(path: p, color: shape.color, lineWidth: shape.lineWidth)
        }
    }
}

class Rock: Sprite {
    let heft: Heft

    enum Heft: CaseIterable {
        case large
        case medium
        case small

        var scale: Double {
            switch self {
            case .large:
                return 1
            case .medium:
                return 0.5
            case .small:
                return 0.25
            }
        }
    }

    private static func randomAxialSpeed() -> Double {
        let absoluteSpeed = Double.random(in: 0.1 ... 6.0)
        return Bool.random() ? absoluteSpeed : -absoluteSpeed
    }

    private static func randomSpeed() -> Vector {
        return [randomAxialSpeed(), randomAxialSpeed()]
    }

    init(position: Point, rotation: Double, index: Int, heft: Heft) {
        self.heft = heft
        let path = Self.allRocks[index]
        let scale = heft.scale
        let speed = Self.randomSpeed()
        let shape = PathShape(path: path, color: .gray, lineWidth: 1.5)
        super.init(position: position, speed: speed, rotation: rotation, scale: scale, pathShapes: [shape])
    }

    static let allRocks = [rock1, rock2, rock3, rock4]

    static let rock1: Path = [
        .addLines([[33, 0], [45, 22], [10, 45], [-22, 45], [-45, 22], [-45, -22], [-22, -45], [0, -23], [22, -45], [45, -22]]),
        .close
    ]

    static let rock2: Path = [
        .addLines([[24, -10], [45, 11], [22, 45], [-12, 34], [-23, 44], [-44, 23], [-33, 0], [-44, -22], [-21, -44], [0, -34], [23, -45], [45, -22]]),
        .close
    ]

    static let rock3: Path = [
        .addLines([[44, 11], [23, 45], [0, 44], [0, 11], [-22, 43], [-43, 10], [-23, 0], [-44, -12], [-11, -44], [23, -44], [44, -13]]),
        .close
    ]

    static let rock4: Path = [
        .addLines([[11, 0], [45, 21], [22, 44], [11, 32], [-22, 44], [-45, 11], [-45, -22], [-12, -23], [-21, -44], [12, -44], [44, -23], [44, -11]]),
        .close
    ]
}

class Saucer: Sprite {
    init(position: Point = .zero) {
        let shape = PathShape(path: Self.saucer, color: .green)
        super.init(position: position, speed: [4, 0], rotation: 0, scale: 0.5, pathShapes: [shape])
    }

    static let saucer: Path = [
        .addLines([[50, 10], [20, 30], [-20, 30], [-50, 10], [-20, -10], [-10, -30], [10, -30], [20, -10]]),
        .close,
        .addLines([[-20, -10], [20, -10]]),
        .addLines([[-50, 10], [50, 10]])
    ]
}

class Player: Sprite {
    init(position: Point = .zero, rotation: Double = 0) {
        let pathShapes: [PathShape] = [
            .init(path: Self.player, color: .white),
            .init(path: Self.playerJet, color: .red)
        ]
        super.init(position: position, speed: .zero, rotation: rotation, scale: 0.25, pathShapes: pathShapes)
    }

    override func update(in canvas: Canvas) {
        super.update(in: canvas)
        rotation += 2°
    }

    static let player: Path = [
        .addLines([[50, 0], [-36, 28], [-22, 15], [-22, -15], [-36, -28]]),
        .close
    ]

    static let playerJet: Path = [
        .addLines([[-22, 15], [-50, 0], [-22, -15]])
    ]
}
