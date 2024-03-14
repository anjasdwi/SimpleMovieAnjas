//
//  UIStackView+DSL.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

extension UIStackView {
    typealias SpacingConfig = (CGFloat, after: UIView)

    /// DSL method for `axis`.
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        return with {
            $0.axis = axis
        }
    }

    /// DSL method for `spacing`.
    @discardableResult
    func spacing(_ spacing: CGFloat = 0) -> Self {
        return with {
            $0.spacing = spacing
        }
    }

    /// DSL method for `distribution`.
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        return with {
            $0.distribution = distribution
        }
    }

    /// DSL method for `alignment`.
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        return with {
            $0.alignment = alignment
        }
    }

    /// DSL method for add multiple subview.
    @discardableResult
    func views(_ views: UIView...) -> Self {
        views.forEach { self.addArrangedSubview($0) }
        return self
    }

    /// DSL method for add multiple custom spacing.
    @discardableResult
    func setCustomSpacing(_ configs: SpacingConfig...) -> Self {
        return with { sv in
            configs.forEach { config in
                sv.setCustomSpacing(config.0, after: config.after)
            }
        }
    }
}

// MARK: - Result builder
extension UIStackView {

    /// DSL method for arranged subviews in initialization without having to type any returns.
    convenience init(@ViewBuilder content: () -> [UIView]) {
        self.init(arrangedSubviews: content())
    }

    /// DSL method for `addArrangedSubviews` in initialization without having to type any returns.
    @discardableResult
    func addArrangedSubviews(@ViewBuilder content: () -> [UIView]) -> Self {
        content().forEach { self.addArrangedSubview($0) }
        return self
    }

}
