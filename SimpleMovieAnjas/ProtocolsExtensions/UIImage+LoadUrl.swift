//
//  UIImage+LoadUrl.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit
import SDWebImage

extension UIImageView {

    /// Method for load image by using url
    func loadImageFrom(
        url: String?,
        onSuccess: (() -> Void)? = nil,
        onError: (() -> Void)? = nil
    ) {
        if let urlString = url, let url = URL(string: urlString) {
            self.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.sd_imageTransition = .fade
            self.sd_setImage(with: url) { _, error, _, _ in
                if error != nil {
                    onError?()
                } else {
                    onSuccess?()
                }
            }
        } else {
            onError?()
        }
    }

}
