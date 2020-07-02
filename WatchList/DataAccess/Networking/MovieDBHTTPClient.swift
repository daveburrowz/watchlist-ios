//
//  MovieDBHTTPClient.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

class MovieDBHTTPClient {
    
    private let httpClient: HTTPClient
    private let rootUrl = URL(string: "https://api.themoviedb.org")!
    private let jsonDecoder = JSONDecoder()
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func send<T: Decodable>(_ components: URLComponents) -> AnyPublisher<Response<T>, Error> {
        var components = components
        components.queryItems = [
            URLQueryItem(name: "api_key", value: "1cc23e7984b2328123afc658c1639796")
        ]
        
        guard let url = components.url(relativeTo: rootUrl) else {
            //May need to throw and do a try map instead
            fatalError()
        }
        let request = URLRequest(url: url)
        return httpClient.send(request, jsonDecoder).eraseToAnyPublisher()
    }
}
