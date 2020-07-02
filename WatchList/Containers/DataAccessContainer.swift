//
//  DataAccessContainer.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class DataAccessContainer {
    var searchRepository: SearchRepository
    var imageUrlRepository: ImageUrlRepository
    
    init() {
        let foundationHTTPClient = FoundationHTTPClient()
        searchRepository = NetworkSearchRepository(httpClient: TraktHTTPClient(httpClient: foundationHTTPClient))
        imageUrlRepository = NetworkImageUrlRepository(httpClient: MovieDBHTTPClient(httpClient: foundationHTTPClient))
    }
}
