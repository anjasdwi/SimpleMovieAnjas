//
//  MovieRepositoryMock.swift
//  SimpleMovieAnjasTests
//
//  Created by Anjas Dwi on 17/03/24.
//

import XCTest
@testable import SimpleMovieAnjas

struct MovieRepositoryMock: MovieRepositoryInterface {
    func getMovieList(
        requestParams: MovieRequestParams,
        completion: @escaping (Result<MovieListModel, NetworkError>) -> Void
    ) {

        switch requestParams.term {
        case "usingempty":
            let model = MovieListModel(search: nil, totalResults: "0", response: "true")
            completion(.success(model))
        case "usingsuccess":
            let detailModels = Array(
                repeating: MovieDetailModel(title: "Test", year: "", type: "", imdbID: "", poster: ""),
                count: 10)
            let model = MovieListModel(search: detailModels, totalResults: "0", response: "true")
            completion(.success(model))
        default:
            completion(.failure(.internalServerError))
        }

    }
}
