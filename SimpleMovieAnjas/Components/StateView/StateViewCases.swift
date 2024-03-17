//
//  StateViewCases.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import Foundation

enum StateViewCases {
    case empty
    case error
    case noConnection

    typealias StateViewParams = (
        description: String,
        illustration: String,
        buttonTitle: String)

    var params: StateViewParams {
        switch self {
        case .empty:
            StateViewParams(description: WORDING.noResultFound,
                            illustration: IMAGE.ill_state,
                            buttonTitle: WORDING.tryAnother)
        case .error:
            StateViewParams(description: WORDING.errorDescription,
                            illustration: IMAGE.ill_state,
                            buttonTitle: WORDING.reloadAgain)
        default:
            StateViewParams(description: WORDING.noConnection,
                            illustration: IMAGE.ill_state,
                            buttonTitle: WORDING.reloadAgain)
        }
    }
}
