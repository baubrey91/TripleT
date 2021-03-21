import UIKit

extension UIView {
    public enum Relation {
        case lessThanOrEqual
        case equal
        case greaterThanOrEqual
    }

    // MARK: - Entire Screen

    @discardableResult
    public func pinEdges(to view: UIView, usingSafeArea: Bool = false, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return [left(equalTo: view, padding: insets.left, usingSafeArea: usingSafeArea, priority: priority),
                right(equalTo: view, padding: insets.right, usingSafeArea: usingSafeArea, priority: priority),
                top(of: view, padding: insets.top, usingSafeArea: usingSafeArea, priority: priority),
                bottom(of: view, padding: insets.bottom, usingSafeArea: usingSafeArea, priority: priority)]
    }

    @discardableResult
    public func pinEdges(to view: UIView, usingSafeArea: Bool = false, padding: CGFloat, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return pinEdges(to: view, usingSafeArea: usingSafeArea, insets: insets, priority: priority)
    }

    // MARK: - Centering

    @discardableResult
    public func center(in view: UIView, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return [centerHorizontally(with: view),
                centerVertically(with: view)]
    }

    public func centerAndSize(in view: UIView, multiplier: CGFloat = 1) {
        center(in: view)
        size(equalTo: view, multiplier: multiplier)
    }

    @discardableResult
    public func centerHorizontally(with view: UIView, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor)
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func centerVertically(with view: UIView, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor)
        constraint.isActive = true
        return constraint
    }

    // MARK: - Sizing

    // MARK: constant sizing

    @discardableResult
    public func widthConstraint(_ width: CGFloat, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return widthAnchor.constraint(lessThanOrEqualToConstant: width)
            case .equal:
                return widthAnchor.constraint(equalToConstant: width)
            case .greaterThanOrEqual:
                return widthAnchor.constraint(greaterThanOrEqualToConstant: width)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func heightConstraint(_ height: CGFloat, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return heightAnchor.constraint(lessThanOrEqualToConstant: height)
            case .equal:
                return heightAnchor.constraint(equalToConstant: height)
            case .greaterThanOrEqual:
                return heightAnchor.constraint(greaterThanOrEqualToConstant: height)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    // maybe deprecate?
    @discardableResult
    public func heightConstraint(minimum: CGFloat, maximum: CGFloat) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let minimumConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: minimum)
        minimumConstraint.isActive = true
        let maximumConstraint = heightAnchor.constraint(lessThanOrEqualToConstant: maximum)
        maximumConstraint.isActive = true
        return [minimumConstraint, maximumConstraint]
    }

    // maybe deprecate?
    @discardableResult
    public func widthConstraint(minimum: CGFloat, maximum: CGFloat) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        let minimumConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: minimum)
        minimumConstraint.isActive = true
        let maximumConstraint = widthAnchor.constraint(lessThanOrEqualToConstant: maximum)
        maximumConstraint.isActive = true
        return [minimumConstraint, maximumConstraint]
    }

    // MARK: Equality sizing

    @discardableResult
    public func width(equalTo view: UIView, multiplier: CGFloat = 1, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return width(equalTo: view.widthAnchor, multiplier: multiplier, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func height(equalTo view: UIView, multiplier: CGFloat = 1, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return height(equalTo: view.heightAnchor, multiplier: multiplier, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    func size(equalTo view: UIView, multiplier: CGFloat = 1, padding: CGFloat = 0) -> [NSLayoutConstraint] {
        return [width(equalTo: view, multiplier: multiplier, padding: padding),
                height(equalTo: view, multiplier: multiplier, padding: padding)]
    }

    // MARK: Inner anchor modifiers

    @discardableResult
    public func width(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: padding)
            case .equal:
                return widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: padding)
            case .greaterThanOrEqual:
                return widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func height(equalTo anchor: NSLayoutDimension, multiplier: CGFloat = 1, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return heightAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: padding)
            case .equal:
                return heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: padding)
            case .greaterThanOrEqual:
                return heightAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    // MARK: - Origin

    // MARK: Vertical Positioning (relative to view)

    @discardableResult
    public func above(view: UIView, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return above(anchor: view.topAnchor, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func below(view: UIView, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return below(anchor: view.bottomAnchor, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func top(of view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return below(anchor: usingSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func bottom(of view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return above(anchor: usingSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, padding: padding, relation: relation, priority: priority)
    }

    // MARK: Vertical Positioning (anchors)

    @discardableResult
    public func below(anchor: NSLayoutYAxisAnchor, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return topAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
            case .equal:
                return topAnchor.constraint(equalTo: anchor, constant: padding)
            case .greaterThanOrEqual:
                return topAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func above(anchor: NSLayoutYAxisAnchor, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return bottomAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
            case .equal:
                return bottomAnchor.constraint(equalTo: anchor, constant: -padding)
            case .greaterThanOrEqual:
                return bottomAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    // MARK: Horizontal Positioning (relative to view)

    @discardableResult
    public func left(equalTo view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return left(equalTo: usingSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, padding: padding, priority: priority)
    }

    @discardableResult
    public func toTheLeft(of view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return right(equalTo: usingSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func right(equalTo view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return right(equalTo: usingSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, padding: padding, priority: priority)
    }

    @discardableResult
    public func toTheRight(of view: UIView, padding: CGFloat = 0, usingSafeArea: Bool = false, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        return left(equalTo: usingSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor, padding: padding, relation: relation, priority: priority)
    }

    @discardableResult
    public func snapSides(to view: UIView, sidePadding: CGFloat = 0, usingSafeArea: Bool = false, priority: UILayoutPriority = .required) -> [NSLayoutConstraint] {
        return [left(equalTo: view, padding: sidePadding, usingSafeArea: usingSafeArea, priority: priority),
                right(equalTo: view, padding: sidePadding, usingSafeArea: usingSafeArea, priority: priority)]
    }

    // MARK: Horizontal Positioning (anchors)

    @discardableResult
    public func left(equalTo anchor: NSLayoutXAxisAnchor, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return leadingAnchor.constraint(lessThanOrEqualTo: anchor, constant: padding)
            case .equal:
                return leadingAnchor.constraint(equalTo: anchor, constant: padding)
            case .greaterThanOrEqual:
                return leadingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    public func right(equalTo anchor: NSLayoutXAxisAnchor, padding: CGFloat = 0, relation: Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint: NSLayoutConstraint = {
            switch relation {
            case .lessThanOrEqual:
                return trailingAnchor.constraint(lessThanOrEqualTo: anchor, constant: -padding)
            case .equal:
                return trailingAnchor.constraint(equalTo: anchor, constant: -padding)
            case .greaterThanOrEqual:
                return trailingAnchor.constraint(greaterThanOrEqualTo: anchor, constant: -padding)
            }
        }()
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    // Auto layout animation helper

    public func layoutIfNeededAnimated(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.layoutIfNeeded()
        }
    }
    
    func rotate() {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
