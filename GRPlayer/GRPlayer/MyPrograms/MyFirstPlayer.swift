//
//  MyProgram.swift
//  GRPlayer
//
//  Created by Wolf McNally on 3/22/21.
//

import GR

class MyFirstPlayer: Program {
    var prevPosition: IntPoint = .zero
    var position: IntPoint = .zero
    var direction: IntVector = .zero
    
    override func setup() {
        canvas.clearColor = nil
        position = canvas.bounds.midXmidY
    }

    override func update() {
        prevPosition = position
        
        position += direction
        
        if direction.dx == 1 && position.x > canvas.bounds.maxX {
            position.x = canvas.bounds.minX
        } else if direction.dx == -1 && position.x < canvas.bounds.minX {
            position.x = canvas.bounds.maxX
        }
        
        if direction.dy == 1 && position.y > canvas.bounds.maxY {
            position.y = canvas.bounds.minY
        } else if direction.dy == -1 && position.y < canvas.bounds.minY {
            position.y = canvas.bounds.maxY
        }

        direction = .zero

        print(position)
    }
    
    override func draw() {
        canvas[prevPosition] = .darkGray
        canvas[position] = .green
    }
    
    override func onEvent(event: Event) {
        switch event {
        case .move(let d):
            direction = d.intOffset
            update()
            display()
        default:
            break
        }
    }
}

