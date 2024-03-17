//
//  UILabel+DSL.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

extension UILabel {

    /// DSL method for `textColor`.
    @discardableResult
    func textColor(_ textColor: UIColor) -> Self {
        return with {
            $0.textColor = textColor
        }
    }

    /// DSL method for `numberOfLines`.
    @discardableResult
    func numberOfLines(_ numberOfLines: Int) -> Self {
        return with {
            $0.numberOfLines = numberOfLines
        }
    }

    /// DSL method for `text`.
    @discardableResult
    func text(_ text: String) -> Self {
        return with {
            $0.text = text
        }
    }

    /// DSL method for `textAlignment`.
    @discardableResult
    func textAlignment(_ align: NSTextAlignment) -> Self {
        return with {
            $0.textAlignment = align
        }
    }

    /// DSL method for `font`.
    @discardableResult
    func font(_ font: UIFont) -> Self {
        return with {
            $0.font = font
        }
    }
}

