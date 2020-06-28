//
//  SearchRepository.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//


import Combine
import Foundation

protocol SearchRepository {
    func search(for query: String) -> AnyPublisher<[SearchResult], Error>
}

class NetworkSearchRepository: SearchRepository {

    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func search(for query: String) -> AnyPublisher<[SearchResult], Error> {

        var components = URLComponents()
           components.scheme = "https"
           components.host = "api.trakt.tv"
           components.path = "/search/movie,show"
           components.queryItems = [
               URLQueryItem(name: "query", value: query),
               URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "30"),
            URLQueryItem(name: "extended", value: "full")
           ]
        guard let url = components.url else { fatalError("URL Malformed") }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2255b9baeb165a50f78bbd1a5778cf54331dc0aa04c36cd973a324b1fbddc959", forHTTPHeaderField: "trakt-api-key")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        return httpClient.send(request, JSONDecoder()).map(\.value)
            .eraseToAnyPublisher()
    }
}
