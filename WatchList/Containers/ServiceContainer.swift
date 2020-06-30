//
//  ServiceContainer.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class ServiceContainer {
    var searchService: SearchService
    
    init(dataAccessContainer: DataAccessContainer) {
        searchService = SearchServiceImpl(searchRepository: dataAccessContainer.searchRepository)
    }
}
