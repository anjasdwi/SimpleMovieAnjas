//
//  MovieRepository.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import RxSwift
import Alamofire

protocol MovieRepositoryInterface {
    func getMovieList(
        requestParams: MovieRequestParams,
        completion: @escaping (Result<MovieListModel, NetworkError>) -> Void)
}

public class MovieRepository: MovieRepositoryInterface {

    func getMovieList(
        requestParams: MovieRequestParams,
        completion: @escaping (Result<MovieListModel, NetworkError>) -> Void
    ) {
        let router = APIMovie.getList(requestParams)
        let networkManager = NetworkServiceManager(router: router)
        networkManager.request(completion: completion)
    }

}
