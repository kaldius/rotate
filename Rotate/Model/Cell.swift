struct Cell: Hashable {
    let center: IntPoint
    var row: Int {
        center.y
    }
    var col: Int {
        center.x
    }
    // 0 degrees is |_
    private(set) var angle: Angle
    var edges: Set<Edge> {
        angle.edges
    }

    init(row: Int, col: Int, angle: Angle = .zero) {
        self.center = IntPoint(x: col, y: row)
        self.angle = angle
    }

    func collides(with otherCell: Cell) -> Bool {
        let otherRow = otherCell.row
        let otherCol = otherCell.col
        if row == otherRow {
            if col == otherCol + 1 {
                return edges.contains(.left) && otherCell.edges.contains(.right)
            } else if col == otherCol - 1 {
                return edges.contains(.right) && otherCell.edges.contains(.left)
            }
        } else if col == otherCell.col {
            if row == otherRow + 1 {
                return edges.contains(.up) && otherCell.edges.contains(.down)
            } else if row == otherRow - 1 {
                return edges.contains(.down) && otherCell.edges.contains(.up)
            }
        }
        return false
    }

    mutating func rotate(clockwise: Bool = true) {
        angle = angle.rotate(clockwise: clockwise)
    }
}
