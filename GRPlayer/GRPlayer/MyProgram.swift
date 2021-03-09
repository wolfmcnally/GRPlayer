//
//  MyProgram.swift
//  GRPlayer
//
//  Created by Wolf McNally on 3/8/21.
//

import GR

struct Ball {
    var x: Int
    var y: Int
    var dx: Int
    var dy: Int
    let color: Color

    // This version works correctly!
    mutating func update(canvas: Canvas) {
        let nx = x + dx
        let ny = y + dy
        
        if nx > canvas.bounds.maxX {
            dx = -dx
        }
        if nx < canvas.bounds.minX {
            dx = -dx
        }

        if ny > canvas.bounds.maxY {
            dy = -dy
        }
        if ny < canvas.bounds.minY {
            dy = -dy
        }
        
        x = x + dx
        y = y + dy
    }

    // See whether you can figure out why this sometimes fails!
    mutating func updateBad(canvas: Canvas) {
        x = x + dx
        if x == canvas.bounds.maxX {
            dx = -dx;
        }
        if x == canvas.bounds.minX {
            dx = -dx;
        }

        y = y + dy
        if y == canvas.bounds.maxY {
            dy = -dy;
        }
        if y == canvas.bounds.minY {
            dy = -dy;
        }
    }
    
    func draw(canvas: Canvas) {
        canvas[x, y] = color
    }
}

class MyProgram: Program {
    var balls: [Ball] = []
    
    override func setup() {
        framesPerSecond = 30
        canvasSize = [55, 40]

        for _ in 0..<20 {
            let ball = Ball(
                x: canvas.bounds.randomX(),
                y: canvas.bounds.randomY(),
                dx: Bool.random() ? -1 : 1,
                dy: Bool.random() ? -1 : 1,
                color: Color.random()
            )

            balls.append(ball)
        }

    }
    
    override func update() {
        for i in balls.indices {
            balls[i].update(canvas: canvas)
        }
    }
    
    override func draw() {
        for ball in balls {
            ball.draw(canvas: canvas)
        }
    }
}
