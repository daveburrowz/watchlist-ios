//
//  SearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import Foundation
import Combine

struct SearchState {
    enum State {
        case empty
        case loaded(searchList: [SearchResult])
    }
    
    var state: State
    var isLoading: Bool
}

enum SearchStateInput {
    case search(for: String)
}

class SearchViewModel: ViewModel {
    
    @Published
    var state: SearchState
    
    @Published
    private var query: String
    
    private var repo = NetworkSearchRepository(httpClient: TraktHTTPClient(httpClient: FoundationHTTPClient()))
    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        state = SearchState(state: .empty, isLoading: false)
        query = ""
        configureSearchDebouncePublisher()
    }
    
    private func configureSearchDebouncePublisher() {
        $query
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in self?.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    func trigger(_ input: SearchStateInput) {
        switch input {
        case .search(let term):
            query = term
            configureState(for: term)
        }
    }
    
    private func configureState(for query: String) {
        if query.count > 0 {
            state.isLoading = true
        } else {
            state = SearchState(state: .empty, isLoading: false)
        }
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            state = SearchState(state: .empty, isLoading: false)
            return
        }
        repo.search(for: query)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                    self?.state = SearchState(state: .loaded(searchList: $0), isLoading: false)
                  }).store(in: &cancelBag)
    }
}
