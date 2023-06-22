import UIKit

class CellView: UIImageView {
    weak var delegate: GameObjectViewDelegate?
    let centerPoint: IntPoint
    var angle: Angle

    init(row: Int,
         col: Int,
         center: CGPoint,
         radius: CGFloat,
         superView: UIView,
         delegate: GameObjectViewDelegate? = nil) {
        let image = UIImage(named: "Cell")
        self.centerPoint = IntPoint(x: col, y: row)
        self.angle = .zero
        super.init(image: image)
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .scaleAspectFit
        self.delegate = delegate

        if delegate != nil {
            addGestureRecognizers()
        }
        setNewConstraints(center: center, radius: radius)
    }

    required init?(coder: NSCoder) {
        self.centerPoint = IntPoint(x: 0, y: 0)
        self.angle = .zero
        super.init(coder: coder)
    }

    func rotate(clockwise: Bool = true) {
        angle = angle.rotate(clockwise: clockwise)
        var rotationAngle = CGFloat.pi / 2
        if !clockwise {
            rotationAngle *= -1
        }
        applyRotateTransform(radians: rotationAngle)
    }

    private func applyRotateTransform(radians angle: CGFloat) {
        self.transform = self.transform.rotated(by: angle)
    }

    private func addGestureRecognizers() {
        self.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }

    private func setNewConstraints(center: CGPoint, radius: CGFloat) {
        guard let superview = self.superview else {
            // TODO: throw error
            assert(false)
        }
        removeAllConstraints()
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.leftAnchor, constant: center.x),
            self.centerYAnchor.constraint(equalTo: superview.topAnchor, constant: center.y),
            self.widthAnchor.constraint(equalToConstant: radius * 2),
            self.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
    }

    private func removeAllConstraints() {
        guard let superview = self.superview else { return }
        for constraint in superview.constraints {
            if let first = constraint.firstItem as? UIView, first == self {
                superview.removeConstraint(constraint)
            }
            if let second = constraint.secondItem as? UIView, second == self {
                superview.removeConstraint(constraint)
            }
        }
        self.removeConstraints(self.constraints)
    }

    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        delegate?.userTappedGameObjectView(sender, row: centerPoint.y, col: centerPoint.x)
    }
}
