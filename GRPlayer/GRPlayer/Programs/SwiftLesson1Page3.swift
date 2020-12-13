import Lores

class SwiftLesson1Page3: SwiftLesson {
    init() {
        let landscape = Landscape(
            rows: [
                "🍏🦋🦋🦋🦋🦋🦋🍏",
                "🦋🍏🦋🦋🍏🍏🦋🦋",
                "🦋🍏🦋🦋🍏🍋🍏🦋",
                "🦋🍏🦋🍏🍋🔳🍋🍋",
                "🍏🍏🦋🦋🦋🦋🦋❤️",
                "🍏🍏🦋🦋🍏➡️🍋🍋",
                "🦋🦋🍏🦋🦋🦋🦋🦋",
                "🦋🦋🦋🦋🦋🦋🦋🦋",
                ])

        super.init(landscape: landscape)
    }

    override func run() {
        moveForward()
        moveForward()
        turnLeft()
        moveForward()
        collectGem()
        moveForward()
        turnLeft()
        moveForward()
        moveForward()
        toggleSwitch()
    }
}
