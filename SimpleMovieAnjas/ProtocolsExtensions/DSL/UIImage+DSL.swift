//
//  UIImage+DSL.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

extension UIImageView {

    /// DSL method for set image.
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        return with {
            $0.image = image
        }
    }

}
