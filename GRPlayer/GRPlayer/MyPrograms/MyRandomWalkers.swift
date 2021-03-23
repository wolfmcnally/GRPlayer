//
//  MyRandomWalkers.swift
//  GRPlayer
//
//  Created by Wolf McNally on 3/22/21.
//

import GR

class MyRandomWalkers: Program {
    var walkers: [Walker] = []
    
    override func setup() {
        framesPerSecond = 30
        canvasSize = [80, 80]
        canvasClearColor = nil

        let colors: [Color] = [.red, .green, .blue, .yellow]
        
        for color in colors {
            let walker = Walker(position: canvas.bounds.midXmidY, color: color, trailColor: color.darkened(by: 0.8))

            walkers.append(walker)
        }
    }
    
    override func update() {
        for walker in walkers {
            walker.update(canvas: canvas)
        }
    }
    
    override func draw() {
        for walker in walkers {
            walker.draw(canvas: canvas)
        }
    }

    class Walker {
        var prevPosition: IntPoint
        var position: IntPoint
        let color: Color
        let trailColor: Color

        init(position: IntPoint, color: Color, trailColor: Color) {
            self.prevPosition = position
            self.position = position
            self.color = color
            self.trailColor = trailColor
        }

        func update(canvas: Canvas) {
            prevPosition = position
            
            let direction = IntVector(dx: Int.random(in: -1...1), dy: Int.random(in: -1...1))
            position += direction
            
            if direction.dx == 1 && position.x > canvas.bounds.maxX {
                position.x = canvas.bounds.minX
            }
            if direction.dx == -1 && position.x < canvas.bounds.minX {
                position.x = canvas.bounds.maxX
            }
            if direction.dy == 1 && position.y > canvas.bounds.maxY {
                position.y = canvas.bounds.minY
            }
            if direction.dy == -1 && position.y < canvas.bounds.minY {
                position.y = canvas.bounds.maxY
            }
        }
        
        func draw(canvas: Canvas) {
            canvas[prevPosition] = trailColor
            canvas[position] = color
        }
    }
}
