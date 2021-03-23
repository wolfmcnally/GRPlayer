//
//  MyProgram.swift
//  GRPlayer
//
//  Created by Wolf McNally on 3/22/21.
//

import GR

class MyRandomWalkProgram: Program {
    var stepsRemaining = 1000
    var prevPosition: IntPoint = .zero
    var position: IntPoint = .zero
    
    override func setup() {
        framesPerSecond = 30
        canvas.clearColor = nil
        position = canvas.bounds.midXmidY
    }

    override func update() {
        if stepsRemaining == 0 {
            return
        }
        
        stepsRemaining -= 1
        
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
    
    override func draw() {
        canvas[prevPosition] = .darkGray
        canvas[position] = .green
    }
}
