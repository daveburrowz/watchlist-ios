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

class TraktHTTPClient {
    
    private let httpClient: HTTPClient
    private let rootUrl = URL(string: "https://api.trakt.tv")!
    private let jsonDecoder = JSONDecoder()
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func send<T: Decodable>(_ components: URLComponents) -> AnyPublisher<Response<T>, Error> {
        
        guard let url = components.url(relativeTo: rootUrl) else {
            //May need to throw and do a try map instead
            fatalError()
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2255b9baeb165a50f78bbd1a5778cf54331dc0aa04c36cd973a324b1fbddc959", forHTTPHeaderField: "trakt-api-key")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        return httpClient.send(request, jsonDecoder).eraseToAnyPublisher()
    }
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
