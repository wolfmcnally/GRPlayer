//
//  HelloPlayer.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/2/21.
//

import GR

class HelloPlayer: Program {
    var playerPosition = IntPoint.zero

    override func setup() {
        playerPosition = canvas.bounds.midXmidY
    }
    
    override func draw() {
        canvas[playerPosition] = .white
    }
    
    override func onEvent(event: Event) {
        var move = IntVector()
        switch event {
        case .move(let direction):
            move = direction.intOffset
        default:
            break
        }
        
        if move != .zero {
            let newPosition = playerPosition + move
            if canvas.bounds.isValidPoint(newPosition) {
                playerPosition += move
                display()
            }
        }
    }
}
