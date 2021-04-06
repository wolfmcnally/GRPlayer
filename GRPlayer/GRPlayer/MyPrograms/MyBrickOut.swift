//
//  MyBrickOut.swift
//  GRPlayer
//
//  Created by Wolf McNally on 4/5/21.
//

import GR
import Interpolate

class MyBrickOut: Program {
    var paddle: Paddle! = nil
    var bricks: Bricks! = nil
    var ball: Ball! = nil
    var score: Score! = nil
    var boundary: Boundary! = nil
    
    override func setup() {
        canvasSize = [80, 60]
        framesPerSecond = 60
        newGame()
    }
    
    override func draw() {
        boundary.draw()
        paddle.draw()
        bricks.draw()
        ball.draw()
    }
    
    override func update() {
        ball.update(bricks: bricks)
    }
    
    func newGame() {
        boundary = Boundary(canvas: canvas)
        paddle = Paddle(canvas: canvas)
        
        let ballPosition = Point(x: canvas.bounds.midX, y: canvas.bounds.midY)
        let ballSpeed = Vector(dx: 0, dy: 0.5)
        ball = Ball(canvas: canvas, position: ballPosition, speed: ballSpeed)
        
        bricks = Bricks(canvas: canvas, gridSize: [20, 8], top: 10)
    }
    
    class Ball {
        let canvas: Canvas
        var position: Point
        var speed: Vector
        
        init(canvas: Canvas, position: Point, speed: Vector) {
            self.canvas = canvas
            self.position = position
            self.speed = speed
        }
        
        func draw() {
            if !isOffBoard {
                canvas[position] = .white
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
                    speed.dy = -speed.dy
                    bricks.removeBrick(gridPoint: gridPoint)
                    
                    let xOffset = speed.dx >= 0 ? 1 : -1
                    let yOffset = speed.dy <= 0 ? -1 : 1
                    let testPoint = IntPoint(x: gridPoint.x + xOffset, y: gridPoint.y + yOffset)
                    if bricks.hasBrick(gridPoint: testPoint) {
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

    class Boundary {
        let canvas: Canvas
        
        init(canvas: Canvas) {
            self.canvas = canvas
        }
        
        func draw() {
            let color = Color.gray
            canvas.drawVerticalLine(in: canvas.bounds.minY ... canvas.bounds.maxY, at: canvas.bounds.minX, color: color)
            canvas.drawVerticalLine(in: canvas.bounds.minY ... canvas.bounds.maxY, at: canvas.bounds.maxX, color: color)
            canvas.drawHorizontalLine(in: canvas.bounds.minX ... canvas.bounds.maxX, at: canvas.bounds.minY, color: color)
        }
    }
    
    class Paddle {
        let canvas: Canvas
        
        init(canvas: Canvas) {
            self.canvas = canvas
        }
        
        func draw() {
            canvas.drawHorizontalLine(in: canvas.bounds.minX ... canvas.bounds.maxX, at: canvas.bounds.maxY, color: .white)
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
            for _ in 0 ..< gridSize.height {
                let row = [Bool](repeating: true, count: gridSize.width)
                grid.append(row)
            }
            self.grid = grid
            
            var rowColors = [Color]()
            for gridY in 0 ..< gridSize.height {
                let hue = Double(gridY).interpolate(from: (0, Double(gridSize.height)), to: (0.0, 360.0))
                let hsbColor = HSBColor(hue: Angle(degrees: hue), saturation: 1, brightness: 1)
                let color = Color(hsbColor)
                rowColors.append(color)
            }
            self.rowColors = rowColors
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
        
        func hasBrick(gridPoint: IntPoint) -> Bool {
            if gridPoint.x < 0 || gridPoint.x > gridSize.width - 1 || gridPoint.y < 0 || gridPoint.y > gridSize.height - 1 {
                return false
            }
            return grid[gridPoint.y][gridPoint.x]
        }
        
        func removeBrick(gridPoint: IntPoint) {
            grid[gridPoint.y][gridPoint.x] = false
        }
        
        func draw() {
            for gridY in 0 ..< gridSize.height {
                for gridX in 0 ..< gridSize.width {
                    let gridPoint = IntPoint(x: gridX, y: gridY)
                    if hasBrick(gridPoint: gridPoint) {
                        let canvasPoint = gridToCanvas(gridPoint: gridPoint)
                        drawBrick(canvasPoint: canvasPoint, color: rowColors[gridY])
                    }
                }
            }
        }
    }
    
    class Score {
        
    }
}
