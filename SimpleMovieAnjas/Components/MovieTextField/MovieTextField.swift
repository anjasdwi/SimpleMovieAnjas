//
//  MovieTextField.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

class MovieTextField: UITextField {

    private let padding = UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 8)

    override var placeholder: String? {
        didSet {
            updatePlaceholderStyle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    func setupStyles() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.withAlphaComponent(0.1).cgColor
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        textColor = .darkGray
        font = .systemFont(ofSize: 14)
    }

    func updatePlaceholderStyle() {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor : UIColor.gray.withAlphaComponent(0.4)]
        )
    }
}
