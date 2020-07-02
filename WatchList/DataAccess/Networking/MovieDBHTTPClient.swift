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
    private let rootUrl = URL(string: "api.themoviedb.org")!
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
        request.addValue("1cc23e7984b2328123afc658c1639796", forHTTPHeaderField: "api-key")
        return httpClient.send(request, jsonDecoder).eraseToAnyPublisher()
    }
}
