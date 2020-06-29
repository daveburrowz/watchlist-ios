//
//  SearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import Foundation
import Combine

class SearchState: ObservableObject {
    @Published var searchList: [SearchResult] = []
    @Published var query = ""
    @Published var isLoading = false
    @Published var isShowingResults = false
}

enum SearchStateInput {
    case search(for: String)
}

class SearchViewModel: ViewModel {
    
    @Published
    var state: SearchState = SearchState()
    
    private var repo = NetworkSearchRepository(httpClient: TraktHTTPClient(httpClient: FoundationHTTPClient()))
    private var cancelBag = Set<AnyCancellable>()

    
    init() {
        configureSearchDebouncePublisher()
        configureShowingResultsPublisher()
        configureIsLoadingPublisher()
    }
    
    private func configureSearchDebouncePublisher() {
        state.$query
            .dropFirst()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in self?.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func configureShowingResultsPublisher() {
        state.$query
            .dropFirst()
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isShowingResults, on: state)
            .store(in: &cancelBag)
    }
    
    private func configureIsLoadingPublisher() {
        state.$query
            .dropFirst()
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isLoading, on: state)
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            state.searchList = []
            return
        }
        repo.search(for: query)
            .sink(receiveCompletion: { [weak self] _ in
                self?.state.isLoading = false
            },
                  receiveValue: { [weak self] in
                    self?.state.searchList = $0
                  }).store(in: &cancelBag)
    }
}
