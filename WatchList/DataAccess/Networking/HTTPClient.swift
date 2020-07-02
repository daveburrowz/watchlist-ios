//
//  HTTPClient.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Combine
import Foundation

protocol HTTPClient {
    func send<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder) -> AnyPublisher<Response<T>, Error>
}

struct Response<T> {
    let value: T
    let response: URLResponse
}

enum HTTPError: Error {
    case unknown
    case statusCode(Int)
}

class FoundationHTTPClient: HTTPClient {

    func send<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                if let httpResponse = result.response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if 200..<300 ~= statusCode {
                        let value = try decoder.decode(T.self, from: result.data)
                        return Response(value: value, response: result.response)
                    } else {
                        throw HTTPError.statusCode(statusCode)
                    }
                }
                throw HTTPError.unknown
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
