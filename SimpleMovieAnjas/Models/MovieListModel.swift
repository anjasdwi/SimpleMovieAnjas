//
//  MovieListModel.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Foundation

struct MovieListModel: Codable {
    let search: [MovieDetailModel]?
    let totalResults: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case totalResults
        case search = "Search"
        case response = "Response"
    }
}
