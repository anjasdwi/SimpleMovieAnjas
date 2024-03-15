//
//  ApiMovie.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Alamofire

enum APIMovie {
    case getList(_ request: MovieRequestParams)
}

extension APIMovie: ApiRouter {

    var actionParameters: [String : Any] {
        switch self {
        case .getList(let request):
            return request.generatedParameters()
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .getList:
            return URLEncoding.queryString
        }
    }

    var authHeader: HTTPHeaders? {
        return [:]
    }

    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        }
    }

    var path: String {
        return ""
    }

    var baseURL: String {
        return API.baseUrl
    }

    func asURLRequest() throws -> URLRequest {
        let originalRequest = try URLRequest(
            url: baseURL.appending(path),
            method: method,
            headers: authHeader)

        var parameters = actionParameters
        parameters.merge(dict: [API.apiKey: API.apiKeyValue])

        var encodedRequest = try encoding.encode(
            originalRequest,
            with: parameters)

        encodedRequest.cachePolicy = .reloadIgnoringCacheData

        print("Fetch data from: ", encodedRequest)

        switch self {
        case .getList:
            return encodedRequest
        }
    }
}
