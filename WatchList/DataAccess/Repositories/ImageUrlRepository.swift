//
//  ImageUrlRepository.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

protocol ImageUrlRepository {
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<URL, Error>
}

class NetworkImageUrlRepository: ImageUrlRepository {
    
    struct MovieDBImageResponse: Decodable {
        let id: Int
        let posters: [MovieDBImage]
    }

    struct MovieDBImage: Decodable {
        let filePath: String
        let iso6391: String?
        let voteAverage: Double
        
        enum CodingKeys: String, CodingKey {
            case filePath = "file_path"
            case iso6391 = "iso_639_1"
            case voteAverage = "vote_average"
        }
    }
    
    enum ImageError: Error {
        case noImage
    }
    
    private var moviePath = "/3/movie/{id}/images";
    private var showPath = "/3/tv/{id}/images";
    private var imagePath = "https://image.tmdb.org/t/p/w342"
    
    private let httpClient: MovieDBHTTPClient
    
    init(httpClient: MovieDBHTTPClient) {
        self.httpClient = httpClient
    }
    
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<URL, Error> {
        var urlPath = path(for: type)
        urlPath = urlPath.replacingOccurrences(of: "{id}", with: String(tmbdId))
        var components = URLComponents()
        components.path = urlPath
        return httpClient.send(components)
            .flatMap({ (response: Response<MovieDBImageResponse>) -> AnyPublisher<URL, Error> in
                return self.url(for: response.value)
            })
            .receive(on: DispatchQueue.main)
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
    
    private func url(for response: MovieDBImageResponse) -> AnyPublisher<URL, Error> {
        Future<URL, Error> { promise in
            DispatchQueue.global(qos: .userInteractive).async {
                
                guard let url = self.url(for: response.posters) else {
                    promise(.failure(ImageError.noImage))
                    return
                }
                promise(.success(url))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func url(for images:  [MovieDBImage]) -> URL? {
        let posters = images.sorted { (image1, image2) -> Bool in
            image1.voteAverage > image2.voteAverage
        }
        let enPosters = posters.filter { (image) -> Bool in
            return image.iso6391 == "en"
        }
        
        var path = ""
        if let poster = enPosters.first {
            path = poster.filePath
        } else if let poster = posters.first {
            path = poster.filePath
        } else {
            return nil
        }
        
        let imageURLPath = imagePath.appending(path)
        return URL(string: imageURLPath)
    }
}
