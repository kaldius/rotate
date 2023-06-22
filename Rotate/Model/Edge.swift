enum Edge {
    case up, down, left, right
}

enum Angle: CaseIterable {
    case zero, ninety, one_eighty, two_seventy

    var edges: Set<Edge> {
        switch self {
        case .zero:
            return Set([.up, .right])
        case .ninety:
            return Set([.right, .down])
        case .one_eighty:
            return Set([.down, .left])
        case .two_seventy:
            return Set([.left, .up])
        }
    }

    func rotate(clockwise: Bool = true) -> Angle {
        let cases = Self.allCases
        let idx = cases.firstIndex(of: self)!
        let newIdx = (idx + 1) % cases.count
        return cases[newIdx]
    }

    func numRotationsFromSelf(to other: Angle) -> Int {
        (Self.allCases.firstIndex(of: other)! - Self.allCases.firstIndex(of: self)!) % Self.allCases.count
    }
}
