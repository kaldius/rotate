import UIKit

protocol GameObjectViewDelegate: AnyObject {
    func userTappedGameObjectView(_ sender: UITapGestureRecognizer, row: Int, col: Int) 
    func viewAnimationDidBegin()
    func viewAnimationDidComplete()
}
