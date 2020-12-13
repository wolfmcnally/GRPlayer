import Lores

class SwiftLesson1Page1: SwiftLesson {
    init() {
        let landscape = Landscape(
            rows: [
                "🍏🍏🍏🍏🍏",
                "🦋🦋🦋🍏🍏",
                "🦋➡️🍋🍋❤️",
                "🦋🦋🦋🦋🍏",
                "🍏🦋🦋🦋🍏",
                ])

        super.init(landscape: landscape)
    }

    override func run() {
        moveForward()
        moveForward()
        moveForward()
        collectGem()
    }
}
