//
//  ApiRouter.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import Alamofire

protocol ApiRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var actionParameters: [String: Any] { get }
    var baseURL: String { get }
    var authHeader: HTTPHeaders? { get }
    var encoding: ParameterEncoding { get }
}
