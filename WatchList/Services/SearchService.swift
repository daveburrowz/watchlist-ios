//
//  SearchService.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation
import Combine

protocol SearchService {
    func search(for query: String) -> AnyPublisher<[SearchResult], Error>
}

class SearchServiceImpl: SearchService {
    
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func search(for query: String) -> AnyPublisher<[SearchResult], Error> {
        return searchRepository.search(for: query)
    }
}
