import GR
import func WolfCore.dispatchOnQueue
import func WolfCore.dispatchOnMain
import Dispatch

public class SwiftLesson: Program {
    private let boardSize: Size
    private let tileSize = LandscapeTileValue.pathShape.size
    private let runQueue = DispatchQueue(label: "run")

    private lazy var landscapeLayer = Board<LandscapeTileValue>(size: boardSize, tileSize: tileSize)
    private lazy var groundLayer = Board<GroundTileValue>(size: boardSize, tileSize: tileSize)
    private lazy var floatingLayer = Board<FloatingTileValue>(size: boardSize, tileSize: tileSize)

    private var player: Player!
    private let landscape: Landscape
    private var gemCount: Int {
        didSet {
            if gemCount == 0 {
                print("❤️ ALL GEMS COLLECTED!")
            }
        }
    }

    private var offTogglesCount: Int {
        didSet {
            if offTogglesCount == 0 {
                print("❤️ ALL SWITCHES ON!")
            }
        }
    }

    public init(landscape: Landscape) {
        self.landscape = landscape
        boardSize = landscape.size
        gemCount = 0
        offTogglesCount = 0
        super.init()

        for y in 0 ..< landscape.rows.count {
            let row = Array(landscape.rows[y])
            for (x, c) in row.enumerated() {
                let p = Point(x: x, y: y)

                landscapeLayer[p] = LandscapeTileValue.tile(for: c)

                if let tile = GroundTileValue.tile(for: c) {
                    groundLayer[p] = tile
                    switch tile {
                    case .toggle(let state):
                        if !state {
                            offTogglesCount += 1
                        }
                    }
                }

                if let heading = Player.heading(for: c) {
                    self.player = Player(heading: heading, boardPosition: p)
                }

                if let tile = FloatingTileValue.tile(for: c) {
                    floatingLayer[p] = tile
                    if tile == .gem {
                        gemCount += 1
                    }
                }
            }
        }
    }


    public override func setup() {
        canvasSize = landscapeLayer.canvasSize
        framesPerSecond = 10

        screenSpec = ScreenSpec(mainLayer: 2, layerSpecs: [
            LayerSpec(),
            LayerSpec(),
            LayerSpec(clearColor: .clear),
            LayerSpec()
            ])

        dispatchOnQueue(runQueue, afterDelay: 1) {
            self.run()
        }
    }

    open func run () {
    }

    public override func draw() {
        landscapeLayer.draw(into: layers[0])
        groundLayer.draw(into: layers[1])
        player.draw(into: layers[2])
        floatingLayer.draw(into: layers[3])
    }

    enum GroundTileValue: TileValue {
        private typealias `Self` = GroundTileValue

        case toggle(Bool)

        var shape: Shape {
            switch self {
            case .toggle(let isOn): return isOn ? Self.toggleOnShape : Self.toggleOffShape
            }
        }

        static func tile(for c: Character) -> GroundTileValue? {
            switch c {
            case "🔳": return .toggle(false)
            case "🔲": return .toggle(true)
            default:
                return nil
            }
        }

        static let toggleOffShape = Shape(
            colors:
            ColorTable([
                "❔": nil,
                "💣": .darkGray
                ]),
            rows: [
                "❔❔💣💣💣❔❔",
                "❔💣💣💣💣💣❔",
                "💣💣💣💣💣💣💣",
                "💣💣💣💣💣💣💣",
                "💣💣💣💣💣💣💣",
                "❔💣💣💣💣💣❔",
                "❔❔💣💣💣❔❔"
            ]
        )

        static let toggleOnShape = Shape(
            colors:
            ColorTable([
                "❔": nil,
                "🦋": .cyan
                ]),
            rows: [
                "❔❔🦋🦋🦋❔❔",
                "❔🦋🦋🦋🦋🦋❔",
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋",
                "❔🦋🦋🦋🦋🦋❔",
                "❔❔🦋🦋🦋❔❔"
            ]
        )
    }

    enum LandscapeTileValue: TileValue {
        private typealias `Self` = LandscapeTileValue

        case path
        case rough
        case water

        var shape: Shape {
            switch self {
            case .path: return Self.pathShape
            case .rough: return Self.roughShape
            case .water: return Self.waterShape
            }
        }

        static func tile(for c: Character) -> LandscapeTileValue {
            switch c {
            case "⬆️", "⬅️", "⬇️", "➡️", "🍋", "❤️", "🔳", "🔲": return .path
            case "🍏": return .rough
            case "🦋": return .water
            default:
                preconditionFailure()
            }
        }

        static let pathShape = Shape(
            colors:
            ColorTable([
                "🍋": .yellow,
                "🐻": Color.yellow.darkened(by: 0.05)
                ]),
            rows: [
                "🐻🐻🐻🐻🐻🐻🐻",
                "🐻🍋🍋🍋🍋🍋🐻",
                "🐻🍋🍋🍋🍋🍋🐻",
                "🐻🍋🍋🍋🍋🍋🐻",
                "🐻🍋🍋🍋🍋🍋🐻",
                "🐻🍋🍋🍋🍋🍋🐻",
                "🐻🐻🐻🐻🐻🐻🐻"
            ]
        )

        static let roughShape = Shape(
            colors:
            ColorTable([
                "💣": Color.brown.darkened(by: 0.2),
                "🐻": .brown
                ]),
            rows: [
                "🐻🐻🐻🐻🐻🐻🐻",
                "🐻💣🐻🐻🐻🐻🐻",
                "🐻🐻💣🐻🐻🐻🐻",
                "🐻🐻🐻🐻🐻💣🐻",
                "🐻🐻🐻💣🐻🐻🐻",
                "🐻🐻🐻🐻🐻🐻🐻",
                "🐻🐻🐻🐻🐻🐻🐻"
                ]
        )

        static let waterShape = Shape(
            colors:
            ColorTable([
                "💭": Color.blue.lightened(by: 0.2),
                "🦋": .blue
                ]),
            rows: [
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋💭🦋🦋🦋",
                "🦋🦋💭🦋💭🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋"
            ]
        )
    }

    struct Player: Sprite {
        private typealias `Self` = Player

        private let tileSize = Self.upShape.size

        init(heading: Heading, boardPosition: Point, offset: Offset = .zero) {
            self.heading = heading
            self.boardPosition = boardPosition
            self.offset = offset
        }

        var heading: Heading
        var boardPosition: Point
        var offset: Offset
        var position: Point {
            return Point(
                x: boardPosition.x * tileSize.width + offset.dx,
                y: boardPosition.y * tileSize.height + offset.dy
            )
        }
        let mode: Shape.Mode = .clip

        var shape: Shape {
            switch heading {
            case .up:
                return Self.upShape
            case .left:
                return Self.leftShape
            case .down:
                return Self.downShape
            case .right:
                return Self.rightShape
            }
        }

        static func heading(for landscapeCharacter: Character) -> Heading? {
            switch landscapeCharacter {
            case "⬆️": return .up
            case "⬅️": return .left
            case "⬇️": return .down
            case "➡️": return .right
            default:
                return nil
            }
        }

        static let upShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔",
                "❔❔🍊🍊🍊❔❔",
                "❔🍊💭💣💭🍊❔",
                "❔🍊🍏🍏🍏🍊❔",
                "❔🍊🍊🍊🍊🍊❔",
                "❔❔🍊🍊🍊❔❔",
                "❔❔❔❔❔❔❔"
            ]
        )

        static let leftShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔",
                "❔❔🍊🍊🍊❔❔",
                "❔🍊💭🍏🍊🍊❔",
                "❔🍊💣🍏🍊🍊❔",
                "❔🍊💭🍏🍊🍊❔",
                "❔❔🍊🍊🍊❔❔",
                "❔❔❔❔❔❔❔"
            ]
        )

        static let downShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔",
                "❔❔🍊🍊🍊❔❔",
                "❔🍊🍊🍊🍊🍊❔",
                "❔🍊🍏🍏🍏🍊❔",
                "❔🍊💭💣💭🍊❔",
                "❔❔🍊🍊🍊❔❔",
                "❔❔❔❔❔❔❔"
            ]
        )

        static let rightShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔",
                "❔❔🍊🍊🍊❔❔",
                "❔🍊🍊🍏💭🍊❔",
                "❔🍊🍊🍏💣🍊❔",
                "❔🍊🍊🍏💭🍊❔",
                "❔❔🍊🍊🍊❔❔",
                "❔❔❔❔❔❔❔"
            ]
        )
    }

    enum FloatingTileValue: TileValue {
        private typealias `Self` = FloatingTileValue

        case gem

        var shape: Shape {
            switch self {
            case .gem:
                return Self.gemShape
            }
        }

        static func tile(for c: Character) -> FloatingTileValue? {
            switch c {
            case "❤️": return .gem
            default:
                return nil
            }
        }

        static let gemShape = Shape(
            colors:
            ColorTable([
                "❔": nil,
                "❤️": Color.red.withAlphaComponent(0.8)
                ]),
            rows: [
                "❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔",
                "❔❔❔❤️❔❔❔",
                "❔❔❤️❤️❤️❔❔",
                "❔❔❔❤️❔❔❔",
                "❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔"
            ]
        )
    }

    public struct Landscape {
        public var rows: [String]

        public var size: Size {
            return Size(width: rows[0].count, height: rows.count)
        }
    }

    private func isPath(at point: Point) -> Bool {
        guard landscapeLayer.bounds.isValidPoint(point) else { return false }
        guard landscapeLayer[point] == .path else { return false }
        return true
    }

    private func moveForward(animated: Bool) {
        defer {
            player.boardPosition += player.heading.offset
        }

        guard animated else { return }
        for _ in 0 ..< tileSize.width {
            player.offset += player.heading.offset
            delay(0.1)
        }
        player.offset = .zero
    }

    private func moveBlocked(animated: Bool) {
        guard animated else { return }
        player.offset += player.heading.offset
        delay(0.1)
        player.offset = .zero
    }
}

extension SwiftLesson {
    private func delay(_ timeInterval: TimeInterval = 1) {
        Thread.sleep(until: Date(timeIntervalSinceNow: timeInterval))
    }

    public var isBlocked: Bool {
        let point = player.boardPosition + player.heading.offset
        return !isPath(at: point)
    }

    public func moveForward() {
        defer { delay(0.5) }

        guard !isBlocked else {
            print("➡️ moveForward: 🚫 BLOCKED")
            moveBlocked(animated: true)
            return
        }

        print("➡️ moveForward: 👍🏼")
        moveForward(animated: true)
    }

    public func turnLeft() {
        defer { delay() }

        print("↪️ turnLeft: 👍🏼")
        player.heading = player.heading.nextCounterClockwise
    }

    private var hasGem: Bool {
        return floatingLayer[player.boardPosition] == .gem
    }

    public func collectGem() {
        defer { delay() }

        guard hasGem else {
            print("💎 collectGem: 🚫 NO GEM")
            return
        }

        print("💎 collectGem: 👍🏼")

        floatingLayer[player.boardPosition] = nil
        gemCount -= 1
    }

    public var hasSwitch: Bool {
        switch groundLayer[player.boardPosition] {
        case .toggle?:
            return true
        default:
            return false
        }
    }

    public func toggleSwitch() {
        defer { delay() }

        switch groundLayer[player.boardPosition] {
        case .toggle(let state)?:
            switch state {
            case false:
                print("🔲 toggleSwitch: 👍🏼 ON")
                offTogglesCount -= 1
                groundLayer[player.boardPosition] = .toggle(true)
            case true:
                print("🔲 toggleSwitch: 👍🏼 OFF")
                offTogglesCount += 1
                groundLayer[player.boardPosition] = .toggle(false)
            }
        default:
            print("🔲 toggleSwitch: 🚫 NO SWITCH")
        }
    }
}
