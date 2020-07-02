//
//  AnySearchViewModel.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

enum AnySearchViewModelResultsState {
    case empty
    case loaded(results: [SearchResult])
    case noResults
    case error
}

struct AnySearchViewModelState {
    var isLoading = false
    var resultsState  = AnySearchViewModelResultsState.empty
}

enum AnySearchInput {
    case search(query: String)
}

class AnySearchViewModel: ViewModel {

    @Published
    var state: AnySearchViewModelState = AnySearchViewModelState()
    
    @Published
    private var query: String = ""

    func trigger(_ input: AnySearchInput) {
        switch input {
        case .search(let query):
            search(query: query)
        }
    }

    private var cancelBag = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        configureSearchDebouncePublisher()
        configureIsLoadingPublisher()
        configureEmptyPublisher()
    }
    
    private func search(query: String) {
        self.query = query
    }
    
    private func configureEmptyPublisher() {
        $query
            .receive(on: RunLoop.main)
            .dropFirst()
            .map({ $0.count == 0 ? AnySearchViewModelResultsState.empty : nil })
            .sink(receiveValue: { [weak self] (state) in
                guard let state = state else { return }
                self?.state.resultsState = state
                self?.searchCancellable = nil
            })
            .store(in: &cancelBag)
    }
    
    private func configureSearchDebouncePublisher() {
        $query
            .dropFirst()
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] in self?.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func configureIsLoadingPublisher() {
        $query
            .dropFirst()
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .sink(receiveValue: { [weak self] in self?.state.isLoading = $0 })
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        state.isLoading = true
        guard query.count > 0 else {
            state.isLoading = false
            return
        }
        searchCancellable = searchService.search(for: query)
            .sink(receiveCompletion: { [weak self] completion in
                self?.state.isLoading = false
                if case .failure = completion {
                    self?.state.resultsState = .error
                }
            },
            receiveValue: { [weak self] results in
                if results.count > 0 {
                    self?.state.resultsState = .loaded(results: results)
                } else {
                    self?.state.resultsState = .noResults
                }
            })
    }
}
