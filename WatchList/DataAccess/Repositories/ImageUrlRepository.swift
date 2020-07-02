//
//  ImageUrlRepository.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

protocol ImageUrlRepository {
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<ImageResponse, Error>
}

struct ImageResponse: Decodable {
    var id: Int
}

class NetworkImageUrlRepository: ImageUrlRepository {
    
    private var moviePath = "/3/movie/{id}/images";
    private var showPath = "/3/tv/{id}/images";
    
    private let httpClient: MovieDBHTTPClient
    
    init(httpClient: MovieDBHTTPClient) {
        self.httpClient = httpClient
    }
    
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<ImageResponse, Error> {
        var urlPath = path(for: type)
        urlPath = urlPath.replacingOccurrences(of: "{id}", with: String(tmbdId))
        var components = URLComponents()
        components.path = urlPath
        return httpClient.send(components).map(\.value)
            .eraseToAnyPublisher()
    }
    
    private func path(for type: MediaType) -> String {
        switch type {
        case .movie:
            return moviePath
        case .show:
            return showPath
        }
    }
}
