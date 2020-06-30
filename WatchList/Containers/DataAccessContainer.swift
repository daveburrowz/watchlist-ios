//
//  DataAccessContainer.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class DataAccessContainer {
    var searchRepository: SearchRepository
    
    init() {
        searchRepository = NetworkSearchRepository(httpClient: TraktHTTPClient(httpClient: FoundationHTTPClient()))
    }
}
