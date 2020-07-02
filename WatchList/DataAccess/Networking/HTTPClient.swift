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

class FoundationHTTPClient: HTTPClient {

    func send<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
