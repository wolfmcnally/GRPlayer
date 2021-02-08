//
//  DrawMaze.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/7/21.
//

import GR
import Foundation

class DrawMaze: Program {
    private var mazeMaker: MazeMaker!
    private var pauseTimer: Timer?
    private var needsDraw: Bool = true
    
    override func setup() {
        framesPerSecond = 30
        let width = Int.random(in: 17...50) * 2 + 1
        let height = Int.random(in: 17...50) * 2 + 1
        canvasSize = [width, height]
        mazeMaker = MazeMaker(size: IntSize(width: (canvas.bounds.width - 1) / 2, height: (canvas.bounds.height - 1) / 2))
        canvas.clearToColor(Color.random())
        canvas.clearColor = nil
        pauseTimer = nil
    }
    
    override func update() {
        guard pauseTimer == nil else { return }
        needsDraw = mazeMaker.isActive
        for _ in 0..<10 {
            if !mazeMaker.step() {
                pauseTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
                    self?.restart()
                }
                break
            }
        }
    }
    
    override func draw() {
        guard needsDraw else { return }
        needsDraw = false
        for y in 0..<mazeMaker.size.height {
            for x in 0..<mazeMaker.size.width {
                let cell = mazeMaker[x, y]
                if cell.hasConnections {
                    let p: IntPoint = [cell.position.x * 2 + 1, cell.position.y * 2 + 1]
                    canvas[p] = mazeMaker.isCellActive(cell) ? .gray : .black
                    for connection in cell.connections {
                        let p2 = p + connection.intOffset
                        canvas[p2] = .black
                    }
                }
            }
        }
    }
}

fileprivate final class MazeMaker {
    let size: IntSize
    var grid: [[Cell]]
    var activeCells = Set<Cell>() // cells that a connection could start from
    var currentCell: Cell
    
    final class Cell: Equatable, Hashable {
        let position: IntPoint
        var connections = Set<Direction>()
        var availableConnections = Set<Direction>()
        
        var hasConnections: Bool {
            !connections.isEmpty
        }
        
        init(position: IntPoint) {
            self.position = position
        }
        
        convenience init() {
            self.init(position: .zero)
        }
        
        static func ==(lhs: Cell, rhs: Cell) -> Bool {
            lhs.position == rhs.position
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(position)
        }
    }
    
    subscript(_ x: Int, _ y: Int) -> Cell {
        grid[y][x]
    }
    
    subscript(_ p: IntPoint) -> Cell {
        grid[p.y][p.x]
    }
    
    func isCellActive(_ cell: Cell) -> Bool {
        return activeCells.contains(cell)
    }
    
    var isActive: Bool {
        return !activeCells.isEmpty
    }
    
    init(size s: IntSize) {
        assert(s.width > 0)
        assert(s.height > 0)
        self.size = s
        
        // Create the grid of Cells
        self.grid = [[Cell]](repeating: [Cell](repeating: Cell(), count: size.width), count: size.height)
        
        for y in 0..<size.height {
            for x in 0..<size.width {
                // Assign the cell its position
                let cell = Cell(position: IntPoint(x: x, y: y))
                grid[y][x] = cell
                
                // Assign the cell the possible ways it can connect to its neighbors
                var d = Set(Direction.allCases)
                if x == 0 { d.remove(.left) }
                if x == size.width - 1 { d.remove(.right) }
                if y == 0 { d.remove(.up) }
                if y == size.height - 1 { d.remove(.down) }

                if !d.isEmpty {
                    cell.availableConnections = d
                }
            }
        }
        
        // Pick any cell that has connections available as a starting point
        let p = size.bounds.randomPoint()
        currentCell = grid[p.y][p.x]
        activeCells.insert(currentCell)
        preventConnection(into: currentCell)
    }
    
    func step() -> Bool {
        // Return if there are no active cells left.
        guard !activeCells.isEmpty else { return false }
        
        // Randomly pick an available connection from the cell
        let connection = currentCell.availableConnections.randomElement()!
        
        // Find the cell we're connecting to.
        let offset = connection.intOffset
        let connectingCell = grid[currentCell.position.y + offset.dy][currentCell.position.x + offset.dx]
        
        // Connect this cell to its neighbor.
        currentCell.connections.insert(connection)
        currentCell.availableConnections.remove(connection)
        
        // Connect the neigboring cell to this one.
        connectingCell.connections.insert(connection.opposite)
        connectingCell.availableConnections.remove(connection.opposite)
        
        // If the neighbor has available connections, make it active.
        if !connectingCell.availableConnections.isEmpty {
            activeCells.insert(connectingCell)
        }
        
        // If this cell has no more available connections, make it inactive.
        if currentCell.availableConnections.isEmpty {
            activeCells.remove(currentCell)
        }

        // Make sure no neighbors can connect into the new cell
        preventConnection(into: connectingCell)
        
        if !connectingCell.availableConnections.isEmpty {
            currentCell = connectingCell
        } else {
            activeCells.remove(connectingCell)
            if activeCells.isEmpty {
                return false
            }
            currentCell = activeCells.first!
        }
        
        // Return true if we're done
        return !activeCells.isEmpty
    }
    
    private func preventConnection(into cell: Cell) {
        for direction in Direction.allCases {
            let neighborPosition = cell.position + direction.intOffset
            guard size.bounds.isValidPoint(neighborPosition) else { continue }
            let neighborCell = self[neighborPosition]
            neighborCell.availableConnections.remove(direction.opposite)
            if neighborCell.availableConnections.isEmpty {
                activeCells.remove(neighborCell)
            }
        }
    }
    
    func run() {
        while step() { }
    }
}
