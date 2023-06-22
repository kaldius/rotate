import UIKit

class BoardRenderer {
    let boardView: UIView
    let cellViewDelegate: GameObjectViewDelegate?
    let animationDuration: Double

    var cellViewMatrix: [[CellView]]

    init(boardView: UIView, board: Board, delegate: GameObjectViewDelegate? = nil, animationDuration: Double = 0.4) {
        self.boardView = boardView
        self.cellViewDelegate = delegate
        self.cellViewMatrix = Array(repeating: [], count: board.numRows)
        self.animationDuration = animationDuration
        initialRender(board: board)
    }

    func delayedRender(board: Board) {
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
            self.cellViewDelegate?.viewAnimationDidBegin()
            self.render(board: board)
        },
                       completion: { _ in
            self.cellViewDelegate?.viewAnimationDidComplete()
        })
    }

    func render(board: Board) {
        for rowNum in 0 ..< board.numRows {
            for colNum in 0 ..< board.numCols {
                let cell = board.matrix[rowNum][colNum]
                let cellView = cellViewMatrix[rowNum][colNum]
                while cell.angle != cellView.angle {
                    cellView.rotate()
                }
            }
        }
    }

    private func initialRender(board: Board) {
        let unit = min(boardView.bounds.width / CGFloat(board.numCols) / 2,
                       boardView.bounds.height / CGFloat(board.numRows) / 2)
        for rowNum in 0 ..< board.numRows {
            for colNum in 0 ..< board.numCols {
                let x = CGFloat(colNum * 2 + 1) * unit
                let y = CGFloat(rowNum * 2 + 1) * unit
                cellViewMatrix[rowNum].append(CellView(row: rowNum,
                                                       col: colNum,
                                                       center: CGPoint(x: x, y: y),
                                                       radius: unit,
                                                       superView: boardView,
                                                       delegate: cellViewDelegate))
            }
        }
    }
}
