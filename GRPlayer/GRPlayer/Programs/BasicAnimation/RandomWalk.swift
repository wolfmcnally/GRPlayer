//
//  RandomWalk.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/7/21.
//

import GR

class RandomWalk: Program {
    var position: IntPoint?
    
    override func setup() {
        framesPerSecond = 30
        canvas.clearColor = nil
    }
    
    override func update() {
        if let position = position {
            canvas[position] = .gray
            
            let dx = [-1, 0, 1].randomChoice()
            let dy = [-1, 0, 1].randomChoice()
            self.position = IntPoint(x: mod(position.x + dx, canvas.bounds.width), y: mod(position.y + dy, canvas.bounds.height))
        } else {
            position = canvas.bounds.midXmidY
        }
        
        canvas[position!] = .red
    }
}
