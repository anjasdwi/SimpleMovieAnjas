//
//  ViewBuilder.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

/// function for create child views for a specific view in a readable way
/// without having to use any return keywords.
@resultBuilder
struct ViewBuilder {
    static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }

}
