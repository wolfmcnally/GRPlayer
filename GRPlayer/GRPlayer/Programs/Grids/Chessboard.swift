import GR

class Chessboard: Program {
    let boardSize = IntSize(width: 8, height: 8)
    let tileSize = IntSize(width: 12, height: 12)

    lazy var bounds = boardSize.bounds

    lazy var squaresLayer = Board<SquareTileValue>(size: boardSize, tileSize: tileSize)
    lazy var piecesLayer = Board<PieceTileValue>(size: boardSize, tileSize: tileSize)

    override func setup() {
        canvasSize = squaresLayer.canvasSize

        for y in bounds.rangeY {
            for x in bounds.rangeX {
                let point = IntPoint(x: x, y: y)

                let squareValue = SquareTileValue(x: x, y: y)
                squaresLayer[point] = squareValue

                if let pieceValue = PieceTileValue.startingValueAtPoint(point) {
                    piecesLayer[point] = pieceValue
                }
            }
        }
    }

    override func draw() {
        squaresLayer.draw(into: backgroundCanvas)
        piecesLayer.draw(into: canvas)
    }

    struct SquareTileValue: TileValue {
        let x: Int
        let y: Int
        let squareColor: SquareColor

        init(x: Int, y: Int) {
            self.x = x
            self.y = y
            squareColor = (x + y) & 1 == 1 ? .dark : .light
        }

        var shape: Shape {
            var shape = Self.squareShape
            shape.colors["🐺"] = squareColor.color
            return shape
        }

        static let squareShape = Shape(
            rows: [
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺",
                "🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺🐺"
            ]
        )
    }

    struct PieceTileValue: TileValue {
        var piece: Piece
        var pieceColor: PieceColor

        var shape: Shape {
            var shape = piece.shape
            shape.colors["💣"] = pieceColor.color
            return shape
        }

        static func startingColorAtPoint(_ point: IntPoint) -> PieceColor {
            switch point.y {
            case 0 ... 3:
                return .black
            case 4 ... 7:
                return .white
            default:
                preconditionFailure()
            }
        }

        static func startingPieceAtPoint(_ point: IntPoint) -> Piece? {
            switch (point.x, point.y) {
            case (_, 2 ... 5):
                return nil
            case (_, 1), (_, 6):
                return .pawn
            case (0, _), (7, _):
                return .rook
            case (1, _), (6, _):
                return .knight
            case (2, _), (5, _):
                return .bishop
            case (3, _):
                return .queen
            case (4, _):
                return .king
            default:
                preconditionFailure()
            }
        }

        static func startingValueAtPoint(_ point: IntPoint) -> PieceTileValue? {
            guard let piece = startingPieceAtPoint(point) else { return nil }
            let color = startingColorAtPoint(point)
            return PieceTileValue(piece: piece, pieceColor: color)
        }
    }

    enum PieceColor {
        case white
        case black

        var color: Color {
            switch self {
            case .white:
                return .white
            case .black:
                return .black
            }
        }
    }

    enum SquareColor {
        case light
        case dark

        private static let lightColor = Color.cyan.darkened(by: 0.2)
        private static let darkColor = Color.cyan.darkened(by: 0.4)

        var color: Color {
            switch self {
            case .light:
                return Self.lightColor
            case .dark:
                return Self.darkColor
            }
        }
    }

    enum Piece {
        case pawn
        case rook
        case knight
        case bishop
        case queen
        case king

        var shape: Shape {
            switch self {
            case .pawn: return Self.pawnShape
            case .rook: return Self.rookShape
            case .knight: return Self.knightShape
            case .bishop: return Self.bishopShape
            case .queen: return Self.queenShape
            case .king: return Self.kingShape
            }
        }

        static let pawnShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔💣💣❔❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔❔💣💣❔❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )

        static let rookShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔💣❔💣💣❔💣❔❔❔",
                "❔❔❔💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )

        static let knightShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔💣💣💣💣❔❔❔❔",
                "❔❔❔💣💣💣💣💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔❔💣💣💣💣❔❔❔",
                "❔❔❔❔💣💣💣💣💣❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )

        static let bishopShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔💣❔❔❔❔❔❔",
                "❔❔❔❔💣💣💣❔❔❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣❔❔❔❔❔",
                "❔❔❔❔❔💣❔❔❔❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )

        static let queenShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔💣❔❔❔❔❔💣❔❔❔",
                "❔❔💣💣❔❔❔💣💣❔❔❔",
                "❔❔💣💣💣❔💣💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔❔❔💣💣💣❔❔❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )

        static let kingShape = Shape(
            rows: [
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔💣❔❔❔❔❔❔",
                "❔❔❔❔💣💣💣❔❔❔❔❔",
                "❔❔❔❔❔💣❔❔❔❔❔❔",
                "❔❔💣💣❔💣❔💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔💣💣💣💣💣❔❔❔❔",
                "❔❔💣💣💣💣💣💣💣❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔",
                "❔❔❔❔❔❔❔❔❔❔❔❔"
            ]
        )
    }
}
