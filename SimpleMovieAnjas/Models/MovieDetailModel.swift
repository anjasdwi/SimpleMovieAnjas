//
//  MovieDetailModel.swift.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Foundation

struct MovieDetailModel: Codable {
    let title: String?
    let year: String?
    let type: String?
    let imdbID: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case imdbID
        case title = "Title"
        case year = "Year"
        case type = "Type"
        case poster = "Poster"
    }
}
