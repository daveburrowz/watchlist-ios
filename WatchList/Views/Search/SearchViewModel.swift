//
//  AnySearchViewModel.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

enum SearchResultsState {
    case loading
    case loaded(results: [SearchResult])
    case noResults
    case error
}

enum AnySearchViewModelResultsState {
    case empty
    case showingResults(SearchResultsState)
}

struct SearchViewModelState {
    var isLoading = false {
        didSet {
            guard case .empty = resultsState, isLoading == true else {
                return
            }
            resultsState = .showingResults(.loading)
        }
    }
    var resultsState  = AnySearchViewModelResultsState.empty
}

enum SearchInput {
    case search(query: String)
}

class SearchViewModel: ViewModel {
    
    @Published
    var state: SearchViewModelState = SearchViewModelState()
    
    @Published
    private var query: String = ""
    
    private var cancelBag = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        configureSearchDebouncePublisher()
    }
    
    func trigger(_ input: SearchInput) {
        switch input {
        case .search(let query):
            search(query: query)
        }
    }
    
    private func search(query: String) {
        self.query = query
        configureState()
    }
    
    private func configureState() {
        if query.count > 0 {
            state.isLoading = true
        } else {
            state.resultsState = .empty
            searchCancellable = nil
            state.isLoading = false
        }
    }
    
    private func configureSearchDebouncePublisher() {
        $query
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in
                self?.search(for: $0)
            })
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            state.isLoading = false
            return
        }
        searchCancellable = searchService.search(for: query)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.state.isLoading = false
                if case .failure = completion {
                    self.state.resultsState = .showingResults(.error)
                }
            },
            receiveValue: { [weak self] results in
                guard let self = self else { return }
                if results.count > 0 {
                    self.state.resultsState = .showingResults(.loaded(results: results))
                } else {
                    self.state.resultsState = .showingResults(.noResults)
                }
            })
    }
}
