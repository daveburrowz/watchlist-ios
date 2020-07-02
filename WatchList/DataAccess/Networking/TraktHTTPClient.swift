//
//  TraktHTTPClient.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

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
