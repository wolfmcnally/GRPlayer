//
//  BrickOut.swift
//  GRPlayer
//
//  Created by Wolf McNally on 3/29/21.
//

import GR
import Interpolate

class BrickOut: Program {
    var state: State! = nil
    var boundary: Boundary! = nil
    var ball: Ball! = nil
    var paddle: Paddle! = nil
    var bricks: Bricks! = nil
    
    override func setup() {
        canvasSize = [80, 60]
        framesPerSecond = 60
        newGame()
    }
    
    func newGame() {
        boundary = Boundary(canvas: canvas)
        
        let ballPosition = Point(x: canvas.bounds.midX, y: canvas.bounds.midY)
        let ballSpeed = Vector(dx: 0, dy: 0.5)
        ball = Ball(canvas: canvas, position: ballPosition, speed: ballSpeed)
        
        paddle = Paddle(canvas: canvas, position: canvas.bounds.minX, width: 10)
//        paddle = Paddle(canvas: canvas, position: canvas.bounds.minX, width: canvas.bounds.width)

        bricks = Bricks(canvas: canvas, gridSize: IntSize(width: 20, height: 8), top: 10)
        
        state = .playing
    }

    override func draw() {
        boundary.draw()
        paddle.draw()
        bricks.draw()
        ball.draw()
    }
    
    override func update() {
        ball.update(bricks: bricks)
        ball.update(bricks: bricks)
    }
    
    override func onEvent(event: Event) {
        switch event {
        case .touchBegan(let p), .touchMoved(let p):
            paddle.x = p.x;
        default:
            break
        }
    }
    
    class Boundary {
        var canvas: Canvas!
        
        init(canvas: Canvas) {
            self.canvas = canvas
        }

        func draw() {
            let color = Color.gray
            canvas.drawVerticalLine(in: canvas.bounds.minY...canvas.bounds.maxY, at: canvas.bounds.minX, color: color)
            canvas.drawVerticalLine(in: canvas.bounds.minY...canvas.bounds.maxY, at: canvas.bounds.maxX, color: color)
            canvas.drawHorizontalLine(in: canvas.bounds.minX...canvas.bounds.maxX, at: canvas.bounds.minY, color: color)
        }
    }
    
    enum State {
        case playing
        case gameOver
    }
    
    class Score {
        init() { }
        
        func draw(canvas: Canvas) {
            
        }
    }
    
    class Ball {
        private let canvas: Canvas
        private var position: Point
        private var speed: Vector
        
        init(canvas: Canvas, position: Point = .zero, speed: Vector = .zero) {
            self.canvas = canvas
            self.position = position
            self.speed = speed
        }
        
        func draw() {
            if !isOffBoard {
//                canvas[position] = .white
                
                let path = Path(circleCenter: position, radius: 1)
                canvas.fill(path: path, color: .white)
            }
        }

        func update(bricks: Bricks) {
            let proposedPosition = position + speed
            
            let bounds = Rect(canvas.bounds)
            
            if proposedPosition.y < bounds.minY {
                speed.dy = -speed.dy
            }
            
            if proposedPosition.x < bounds.minX || proposedPosition.x > bounds.maxX {
                speed.dx = -speed.dx
            }
            
            if proposedPosition.y > bounds.maxY {
                speed.dy = -speed.dy
                speed.dx = Double.random(in: -1...1)
            }

            if let gridPoint = bricks.canvasToGrid(canvasPoint: IntPoint(position)) {
                if bricks.hasBrick(gridPoint: gridPoint) {
                    bricks.removeBrick(gridPoint: gridPoint)
                    speed.dy = -speed.dy

                    let xOffset = speed.dx >= 0 ? 1 : -1
                    let yOffset = speed.dy <= 0 ? -1 : 1
                    if bricks.hasBrick(gridPoint: IntPoint(x: gridPoint.x + xOffset, y: gridPoint.y + yOffset)) {
                        speed.dx = -speed.dx + Double.random(in: -0.5 ... 0.5)
                    }
                }
            }
            
            position = position + speed
        }
        
        var isOffBoard: Bool {
            let bounds = Rect(canvas.bounds)
            return !bounds.contains(position)
        }
    }
    
    class Paddle {
        let canvas: Canvas
        var position: Int
        var width: Int
        
        var x: Double = 0 {
            didSet {
                let minX = Double(canvas.bounds.minX)
                let maxX = Double(canvas.bounds.maxX)
                let minPosition = Double(canvas.bounds.minX)
                let maxPosition = Double(canvas.bounds.maxX - width)
                let newPosition = x.interpolate(from: (minX, maxX), to: (minPosition, maxPosition))
                position = Int(newPosition)
            }
        }

        init(canvas: Canvas, position: Int, width: Int) {
            self.canvas = canvas
            self.position = position
            self.width = width
        }
        
        func draw() {
            canvas.drawHorizontalLine(in: position...(position + width), at: canvas.bounds.maxY, color: .white)
        }
    }
    
    class Bricks {
        let canvas: Canvas
        let gridSize: IntSize
        let top: Int

        let brickSize: IntSize
        var grid: [[Bool]]
        let rowColors: [Color]
        
        init(canvas: Canvas, gridSize: IntSize, top: Int) {
            self.canvas = canvas
            self.gridSize = gridSize
            self.top = top

            let brickWidth = canvas.bounds.width / gridSize.width
            let brickHeight = 2
            self.brickSize = IntSize(width: brickWidth, height: brickHeight)

            var grid = [[Bool]]()
            for _ in 0..<gridSize.height {
                let row = [Bool](repeating: true, count: gridSize.width)
                grid.append(row)
            }
            self.grid = grid
            
            var rowColors: [Color] = []
            for gridY in 0 ..< gridSize.height {
                let hue = Double(gridY).interpolate(from: (0, Double(gridSize.height)), to: (0.0, 360.0))
                let hsbColor = HSBColor(hue: Angle(degrees: hue), saturation: 1, brightness: 1)
                let color = Color(hsbColor)
                rowColors.append(color)
            }
            self.rowColors = rowColors
        }
        
        func canvasToGrid(canvasPoint: IntPoint) -> IntPoint? {
            let x = canvasPoint.x / brickSize.width
            let y = (canvasPoint.y - top) / brickSize.height
            if x < 0 || x > gridSize.width - 1 || y < 0 || y > gridSize.height - 1 {
                return nil
            }
            return IntPoint(x: x, y: y)
        }
        
        func gridToCanvas(gridPoint: IntPoint) -> IntPoint {
            let x = gridPoint.x * brickSize.width
            let y = gridPoint.y * brickSize.height + top
            return IntPoint(x: x, y: y)
        }
        
        func drawBrick(canvasPoint: IntPoint, color: Color) {
            let y1 = canvasPoint.y
            let y2 = y1 + brickSize.height - 1
            let x1 = canvasPoint.x
            let x2 = x1 + brickSize.width - 1
            for y in y1...y2 {
                canvas.drawHorizontalLine(in: x1...x2, at: y, color: color)
            }
        }
        
        func hasBrick(gridPoint: IntPoint) -> Bool {
            if gridPoint.x < 0 || gridPoint.x >= gridSize.width || gridPoint.y < 0 || gridPoint.y >= gridSize.height {
                return false
            }
            return grid[gridPoint.y][gridPoint.x]
        }
        
        func removeBrick(gridPoint: IntPoint) {
            grid[gridPoint.y][gridPoint.x] = false
        }
        
        func draw() {
            for gridY in 0..<gridSize.height {
                for gridX in 0..<gridSize.width {
                    if hasBrick(gridPoint: IntPoint(x: gridX, y: gridY)) {
                        let canvasPoint = gridToCanvas(gridPoint: IntPoint(x: gridX, y: gridY))
                        drawBrick(canvasPoint: canvasPoint, color: rowColors[gridY])
                    }
                }
            }
        }
    }
}
