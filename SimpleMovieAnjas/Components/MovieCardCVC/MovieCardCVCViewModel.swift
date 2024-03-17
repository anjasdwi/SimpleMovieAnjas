//
//  MovieCardCVCViewModel.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import Foundation

struct MovieCardCVCViewModel {
    let title: String
    let year: String
    let posterUrl: String

    private let type: String
    var typeFormatted: String {
        type.capitalized
    }

    init(
        title: String = "-",
        year: String = "-",
        type: String = "-",
        posterUrl: String = "-"
    ) {
        self.title = title
        self.year = year
        self.type = type
        self.posterUrl = posterUrl
    }
}
