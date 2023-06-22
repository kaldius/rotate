//
//  ViewController.swift
//  Rotate
//
//  Created by Quan Teng Foong on 20/6/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: UIView!
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
        let numRows = 10
        let numCols = 10
        board = Board(numRows: numRows, numCols: numCols, delegate: self)
        boardRenderer = BoardRenderer(boardView: boardView, board: board, delegate: self)

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        boardRenderer.render(board: board)
    }

    func updateOnce() {
        if board.update() {
            boardRenderer.delayedRender(board: board)
        }
    }
}

extension ViewController: BoardDelegate {
    func didChange() {
        boardRenderer.render(board: board)
    }
}

extension ViewController: GameObjectViewDelegate {
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
