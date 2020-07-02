//
//  ImageUrlService.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

protocol ImageUrlService {
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<ImageResponse, Error>
}

class ImageUrlServiceImpl: ImageUrlService {
    
    private let imageUrlRepository: ImageUrlRepository
    
    init(imageUrlRepository: ImageUrlRepository) {
        self.imageUrlRepository = imageUrlRepository
    }
    
    func url(tmbdId: Int, type: MediaType) -> AnyPublisher<ImageResponse, Error> {
        return imageUrlRepository.url(tmbdId: tmbdId, type: type)
    }
}
