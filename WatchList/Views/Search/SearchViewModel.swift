//
//  SearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import Foundation
import Combine

struct SearchState {
    var searchList: [SearchResult]
}

enum SearchStateInput {
    case search(for: String)
}

class SearchViewModel: ViewModel {
    
    @Published
    var state: SearchState
    var repo = NetworkSearchRepository(httpClient: FoundationHTTPClient())
    var cancelBag = Set<AnyCancellable>()
    
    init() {
        state = SearchState(searchList: [])
    }
    
    func trigger(_ input: SearchStateInput) {
        switch input {
        case .search(let term):
            search(for: term)
        }
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            state = SearchState(searchList: [])
            return
        }
        repo.search(for: query)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                    self?.state = SearchState(searchList: $0)
                  }).store(in: &cancelBag)
    }
}
