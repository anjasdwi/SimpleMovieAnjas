//
//  UIView+DSL.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

extension UIView {

    /// DSL method for `addSubview` in initialization without having to type any returns.
    convenience init(@ViewBuilder views: () -> [UIView]) {
        self.init()
        views().forEach { addSubview($0) }
    }

    /// DSL method for each subviews which added to view
    /// example: addSubviews { button }
    @discardableResult
    func addSubviews(@ViewBuilder views: () -> [UIView]) -> Self {
        views().forEach { self.addSubview($0) }
        return self
    }

    /// DSL method for `setContentHuggingPriority`.
    @discardableResult
    func setContentHuggingPriority(_ priority: UILayoutPriority, _ axis: NSLayoutConstraint.Axis) -> Self {
        return with {
            $0.setContentHuggingPriority(priority, for: axis)
        }
    }

    /// DSL method for `setContentCompressionResistancePriority`.
    @discardableResult
    func setContentCompressionResistancePriority(_ priority: UILayoutPriority, _ axis: NSLayoutConstraint.Axis) -> Self {
        return with {
            $0.setContentCompressionResistancePriority(priority, for: axis)
        }
    }

    /// DSL method for `backgroundColor`.
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        return with {
            $0.backgroundColor = color
        }
    }

    /// DSL method for `layer.cornerRadius`.
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Self {
        return with {
            $0.layer.cornerRadius = radius
        }
    }

    /// DSL method for `contentMode`.
    @discardableResult
    func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        return with {
            $0.contentMode = contentMode
        }
    }

    /// DSL method for set `tintcolor`
    @discardableResult
    func tintColor(_ tintColor: UIColor) -> Self {
        return with {
            $0.tintColor = tintColor
        }
    }

    /// DSL method for `translatesAutoresizingMaskIntoConstraints`.
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ status: Bool) -> Self {
        return with {
            $0.translatesAutoresizingMaskIntoConstraints = status
        }
    }
}
