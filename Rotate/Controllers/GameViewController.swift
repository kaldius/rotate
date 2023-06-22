import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var pointsCounter: UITextView!

    var numRows: Int = 2
    var numCols: Int = 2
    var board: Board!
    var boardRenderer: BoardRenderer!
    var viewAnimationInProgress: Bool = false {
        didSet {
            if !viewAnimationInProgress {
                updateOnce()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        board = Board(numRows: numRows, numCols: numCols, delegate: self)
        boardRenderer = BoardRenderer(boardView: boardView, board: board, delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        boardRenderer.render(board: board)
    }

    func updateOnce() {
        if board.update() {
            boardRenderer.delayedRender(board: board)
            pointsCounter.text = "Collisions: \(board.points)"
        }
    }

    @IBAction func quitButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension GameViewController: BoardDelegate {
    func didChange() {
        boardRenderer.render(board: board)
    }
}

extension GameViewController: GameObjectViewDelegate {
    func viewAnimationDidBegin() {
        viewAnimationInProgress = true
    }

    func viewAnimationDidComplete() {
        viewAnimationInProgress = false
    }

    func userTappedGameObjectView(_ sender: UITapGestureRecognizer, row: Int, col: Int) {
        board.rotate(row: row, col: col)
        boardRenderer.delayedRender(board: board)
    }
}
