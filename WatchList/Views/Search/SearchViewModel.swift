//
//  BindableSearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation
import Combine

protocol SearchViewModel {
    var state: SearchViewModelState { get }
}

enum SearchViewModelResultsState {
    case empty
    case loaded(results: [SearchResult])
    case noResults
    case error
}

class SearchViewModelState: ObservableObject {
    @Published var query = ""
    @Published var isLoading = false
    @Published var resultsState  = SearchViewModelResultsState.empty
}

class SearchViewModelImpl: SearchViewModel {
    
    var state: SearchViewModelState = SearchViewModelState()
    
    private var cancelBag = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        configureSearchDebouncePublisher()
        configureIsLoadingPublisher()
        configureEmptyPublisher()
    }
    
    private func configureEmptyPublisher() {
        state.$query
            .receive(on: RunLoop.main)
            .map({ $0.count == 0 ? SearchViewModelResultsState.empty : nil })
            .sink(receiveValue: { [weak self] (state) in
                guard let state = state else { return }
                self?.state.resultsState = state
                self?.searchCancellable = nil
            })
            .store(in: &cancelBag)
    }
    
    private func configureSearchDebouncePublisher() {
        state.$query
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { self.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func configureIsLoadingPublisher() {
        state.$query
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isLoading, on: state)
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
