//
//  MovieRequestParams.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import Foundation

struct MovieRequestParams {
    let term: String
    let page: Int

    func generatedParameters() -> [String: AnyObject] {
        var parameters: [String: AnyObject] = [:]
        parameters["s"] = term as AnyObject?
        parameters["page"] = page as AnyObject?

        return parameters
    }
}
