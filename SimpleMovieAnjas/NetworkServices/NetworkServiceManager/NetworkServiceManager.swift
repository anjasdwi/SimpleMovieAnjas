//
//  NetworkServiceManager.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import Alamofire

protocol NetworkServiceManagerProtocol {
    var session: Session { get }
    var router: ApiRouter { get set }

    func request<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> Void)
}

class NetworkServiceManager: NetworkServiceManagerProtocol {

    var session: Session = Session.default
    var router: ApiRouter

    required init(router: ApiRouter) {
        self.router = router
    }

    /// Network Call Request
    /// - Parameter router: endpoint your module / API / content
    /// - Parameter completion: escaping closure for handle the result
    func request<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> Void) {
        session.request(router)
            .validate()
            .responseDecodable(of: T.self, completionHandler: { data in
                switch data.result {
                case let .success(data):
                    completion(.success(data))
                case let .failure(error):
                    print("Request Error", error)
                    completion(.failure(.internalServerError))
                }
            })
    }

}
