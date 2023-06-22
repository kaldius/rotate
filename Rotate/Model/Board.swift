struct Board {
    let DEFAULTROTATIONCLOCKWISE: Bool = true

    let numRows: Int
    let numCols: Int
    var points: Int = 0
    var matrix: [[Cell]]
    var delegate: BoardDelegate?

    var matrixAsArray: [Cell] {
        matrix.flatMap({ $0 })
    }

    init(numRows: Int, numCols: Int, delegate: BoardDelegate?) {
        self.numRows = numRows
        self.numCols = numCols
        self.matrix = Array(repeating: [], count: numRows)
        self.delegate = delegate
        for row in 0 ..< numRows {
            for col in 0 ..< numCols {
                let newCell = Cell(row: row, col: col)
                matrix[row].append(newCell)
            }
        }
    }

    mutating func rotate(row: Int, col: Int, clockwise: Bool = true) {
        matrix[row][col].rotate(clockwise: clockwise)
    }

    subscript(_ intPoint: IntPoint) -> Cell {
        matrix[intPoint.y][intPoint.x]
    }

    // TODO: can be optimized by only looking at 3x3 grid around most recently rotated cell
    /// For each pair of `Cell`s that collide with each other, rotates both of them in
    /// the default direction.
    ///
    /// - Returns: `true` if an update occured, `false` otherwise.
    @discardableResult
    mutating func update() -> Bool {
        var updated = false
        let copiedMatrixAsArray = matrixAsArray
        var toRotate = Set<IntPoint>()
        for cell in copiedMatrixAsArray {
            for otherCell in copiedMatrixAsArray where cell != otherCell {
                if cell.collides(with: otherCell) {
                    if !toRotate.contains(cell.center) {
                        toRotate.insert(cell.center)
                    }
                    if !toRotate.contains(otherCell.center) {
                        toRotate.insert(otherCell.center)
                    }
                    points += 1
                    updated = true
                }
            }
        }
        toRotate.forEach({ intPoint in
            matrix[intPoint.y][intPoint.x].rotate(clockwise: DEFAULTROTATIONCLOCKWISE)
        })
        return updated
    }
}
