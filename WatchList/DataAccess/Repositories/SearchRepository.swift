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
    
    private let httpClient: TraktHTTPClient
    
    init(httpClient: TraktHTTPClient) {
        self.httpClient = httpClient
    }
    
    func search(for query: String) -> AnyPublisher<[SearchResult], Error> {
        
        var components = URLComponents()
        components.path = "/search/movie,show"
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "limit", value: "30"),
            URLQueryItem(name: "extended", value: "full")
        ]
        return httpClient.send(components).map(\.value)
            .eraseToAnyPublisher()
    }
}
