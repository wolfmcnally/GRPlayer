import GR

class DripProgram: Program {
    private let percentObstacles: Frac = 0.3
    private let framesPerDrip = 20
    private let basinColor = Color.white.darkened(by: 0.2)
    private let obstacleColor = Color.orange.darkened(by: 0.6)
    private let movingDripColor = Color.blue.lightened(by: 0.4)
    private let dripColor = Color.blue.lightened(by: 0.2)

    private struct Drip {
        let backgroundCanvas: Canvas
        var position: Point = .zero
        var direction = Vector(dx: 0, dy: 1)
        var frameCount = 0

        init(backgroundCanvas: Canvas, position: Point) {
            self.backgroundCanvas = backgroundCanvas
            self.position = position
        }

        func isEmpty(at offset: Vector) -> Bool {
            let pos = position + offset
            guard backgroundCanvas.bounds.isValidPoint(pos) else { return false }
            return backgroundCanvas[pos] == .clear
        }
    }

    private var drips = [Drip]()

    override func setup() {
        //canvasSize = Size(width: 200, height: 200)
        //canvasSize = Size(width: 20, height: 100)
        backgroundCanvas.clearColor = nil
        framesPerSecond = 30

        drawBasin()
        drawObstacles()
    }

    private func draw(drip: Drip) {
        canvas[drip.position] = movingDripColor
    }

    override func draw() {
        for drip in drips {
            draw(drip: drip)
        }
    }

    override func update() {
        if frameNumber % framesPerDrip == 0 {
//            for _ in 1 ... 4 {
                addDrip()
//            }
        }

        var indexesToRemove = [Int]()
        for i in 0 ..< drips.count {
            guard update(drip: &drips[i]) else { continue }
            backgroundCanvas[drips[i].position] = dripColor
            indexesToRemove.append(i)
        }

        indexesToRemove.reversed().forEach { drips.remove(at: $0) }
    }

    private func update(drip: inout Drip) -> Bool {
        defer { drip.frameCount += 1 }

        guard drip.frameCount > 0 else { return false }

        // assume the drip can move *somewhere*
        var canMove = true

        // if the drip can move down
        if drip.isEmpty(at: .down) {
            // make the drip direction down
            drip.direction = .down
            // else we are blocked from moving down
        } else {
            // if the direction is "down" then try to start moving left or right
            if drip.direction == .down { // here we check the direction we moved last frame
                // flip a coin for "check left first" or "check right first"
                switch Bool.random() {
                // if "check left first"
                case true:
                    // if the drip can move to the left
                    if drip.isEmpty(at: .left) {
                        // make the drip direction left
                        drip.direction = .left
                        // else if the drip can move to the right
                    } else if drip.isEmpty(at: .right) {
                        // make the drip direction right
                        drip.direction = .right
                        // else we know the drip cannot move at all
                    } else {
                        canMove = false;
                    }
                // else we're "checking right first"
                case false:
                    // if the drip can move to the right
                    if drip.isEmpty(at: .right) {
                        // make the drip direction right
                        drip.direction = .right
                        // else if the drip can move to the left
                    } else if drip.isEmpty(at: .left) {
                        // make the drip direction left
                        drip.direction = .left
                        // else we know the drip cannot move at all
                    } else {
                        canMove = false;
                    }
                }

                // else we are already moving left or right
            } else {
                // if we can't move in the left or right
                // direction we moved in last frame
                if !drip.isEmpty(at: drip.direction)  {
                    // we're done moving
                    canMove = false;
                }
            }
        }

        // if the drip can move
        if(canMove) {
            // move the drip in the drip direction
            drip.position += drip.direction

            return false
        } else {
            return true
        }
    }

    private func drawBasin() {
        let bounds = backgroundCanvas.bounds
        backgroundCanvas.drawVerticalLine(in: bounds.minY ..< bounds.maxY, at: bounds.minX, color: basinColor)
        backgroundCanvas.drawVerticalLine(in: bounds.minY ..< bounds.maxY, at: bounds.maxX - 1, color: basinColor)
        backgroundCanvas.drawHorizontalLine(in: bounds.minX ..< bounds.maxX, at: bounds.maxX - 1, color: basinColor)
    }

    private func drawObstacles() {
        let bounds = backgroundCanvas.bounds.intView

        for y in bounds.minY + 5 ... bounds.maxY - 1 {
            for x in bounds.minX + 1 ... bounds.maxX - 1 {
                if Double.randomFrac() <= percentObstacles {
                    backgroundCanvas[x, y] = obstacleColor
                }
            }
        }
    }

    private func randomStartPosition() -> Point? {
        let bounds = canvas.bounds.intView

        var startPositions = [Point]()
        for x in bounds.rangeX {
            let p = Point(x: x, y: bounds.minY)
            if canvas[p] == .clear {
                startPositions.append(p)
            }
        }

        guard startPositions.count > 0 else { return nil }

        startPositions = startPositions.shuffled()
        return startPositions[0]
    }

    private func centerStartPosition() -> Point? {
        let bounds = canvas.bounds.intView
        let startPosition = Point(x: bounds.midX, y: bounds.minY)
        guard backgroundCanvas[startPosition] == .clear else { return nil }
        return startPosition
    }

    private func addDrip() {
        guard let startPosition = centerStartPosition() else {
            setup()
            return
        }

        let drip = Drip(backgroundCanvas: backgroundCanvas, position: startPosition)
        drips.append(drip)
    }
}
