import Lores

class SwiftLesson1Page2: SwiftLesson {
    init() {
        let landscape = Landscape(
            rows: [
                "🍋🍋🍋🍏🦋",
                "🦋🦋🍋🦋🦋",
                "🦋🦋❤️🦋🦋",
                "🦋🦋🍋🦋🦋",
                "➡️🍋🍋🍏🦋",
                ])

        super.init(landscape: landscape)
    }

    override func run() {
        moveForward()
        moveForward()
        turnLeft()
        moveForward()
        moveForward()
        collectGem()
    }
}
