import GR

class Mushrooms: Program {
    override func draw() {
        drawMushroom(x: 10, y: 10, color: .red)
        drawMushroom(x: 24, y: 24, color: .green)
        drawMushroom(x: 0, y: 24, color: .purple)
    }
    
    // Black 💣
    // White 👻
    // Red 🍒
    // Clear ❕
    // Yellow 🍌
    // Blue 🦋
    // Pink 🎀
    func drawMushroom(x: Int, y: Int, color: Color) {
        let s = [
            "❔❔❔❔❔💣💣💣💣💣💣❔❔❔❔❔",
            "❔❔❔💣💣🍒🍒🍒🍒👻👻💣💣❔❔❔",
            "❔❔💣👻👻🍒🍒🍒🍒👻👻👻👻💣❔❔",
            "❔💣👻👻🍒🍒🍒🍒🍒🍒👻👻👻👻💣❔",
            "❔💣👻🍒🍒👻👻👻👻🍒🍒👻👻👻💣❔",
            "💣🍒🍒🍒👻👻👻👻👻👻🍒🍒🍒🍒🍒💣",
            "💣🍒🍒🍒👻👻👻👻👻👻🍒🍒👻👻🍒💣",
            "💣👻🍒🍒👻👻👻👻👻👻🍒👻👻👻👻💣",
            "💣👻👻🍒🍒👻👻👻👻🍒🍒👻👻👻👻💣",
            "💣👻👻🍒🍒🍒🍒🍒🍒🍒🍒🍒👻👻🍒💣",
            "💣👻🍒🍒💣💣💣💣💣💣💣💣🍒🍒🍒💣",
            "❔💣💣💣👻👻💣👻👻💣👻👻💣💣💣❔",
            "❔❔💣👻👻👻💣👻👻💣👻👻👻💣❔❔",
            "❔❔💣👻👻👻👻👻👻👻👻👻👻💣❔❔",
            "❔❔❔💣👻👻👻👻👻👻👻👻💣❔❔❔",
            "❔❔❔❔💣💣💣💣💣💣💣💣❔❔❔❔"
        ]
        
        for dy in 0 ..< s.count {
            let row = s[dy]
            drawRow(row: row, x: x, y: y + dy, color: color)
        }
    }
    
    func drawRow(row: String, x: Int, y: Int, color: Color) {
        let characters = Array(row)
        for dx in 0 ..< characters.count {
            let pixelColor: Color?
            
            switch characters[dx] {
            case "🍒":
                pixelColor = color
            case "💣":
                pixelColor = .black
            case "👻":
                pixelColor = .white
            default:
                pixelColor = nil
            }
            
            guard let c = pixelColor else { continue }
            canvas[x + dx, y] = c
        }
    }
}

