//
//  MyRectangles.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/15/21.
//

import GR

class MyRectangles: Program {
    override func draw() {
        outlineRectangle(left: 8, top: 13, width: 10, height: 17, color: Color(red: 0.5, green: 0.25, blue: 0))
        outlineRectangle(left: 10, top: 15, width: 10, height: 17, color: Color.darkGreen)
        outlineRectangle(left: 13, top: 20, width: 18, height: 20, color: Color.yellow)
        fillRectangle(left: 5, top: 8, width: 17, height: 7, color: Color.red)
        
        fillRectangle(left: 20, top: 3, width: 10, height: 10, color: Color.yellow)
        outlineRectangle(left: 20, top: 3, width: 10, height: 10, color: Color.blue)
    }
    
    func outlineRectangle(left x1: Int, top y1: Int, width: Int, height: Int, color: Color) {
        let x2 = x1 + width - 1
        let y2 = y1 + height - 1
        
        drawHorizontalLine(x1: x1, x2: x2, y: y1, color: color)
        drawHorizontalLine(x1: x1, x2: x2, y: y2, color: color)
        drawVerticalLine  (y1: y1, y2: y2, x: x1, color: color)
        drawVerticalLine  (y1: y1, y2: y2, x: x2, color: color)
    }
    
    func fillRectangle(left x1: Int, top y1: Int, width: Int, height: Int, color: Color) {
        let x2 = x1 + width - 1
        let y2 = y1 + height - 1

        for y in y1...y2 {
            for x in x1...x2 {
                canvas[x, y] = color
            }
        }
    }
    
    func drawHorizontalLine(x1: Int, x2: Int, y: Int, color: Color) {
        for x in x1...x2 {
            canvas[x, y] = color
        }
    }
    
    func drawVerticalLine(y1: Int, y2: Int, x: Int, color: Color) {
        for y in y1...y2 {
            canvas[x, y] = color
        }
    }
}
