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
    var statePublished: Published<SearchViewModelState> { get }
    var statePublisher: Published<SearchViewModelState>.Publisher { get }
}

class SearchViewModelState: ObservableObject {
    @Published var searchList: [SearchResult] = []
    @Published var query = ""
    @Published var isLoading = false
    @Published var isShowingResults = false
}

class BindableSearchViewModel: ObservableObject, SearchViewModel {
    
    @Published
    var state: SearchViewModelState = SearchViewModelState()
    
    var statePublished: Published<SearchViewModelState> {
        _state
    }
    
    var statePublisher: Published<SearchViewModelState>.Publisher {
        $state
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let searchService: SearchService
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        configureSearchDebouncePublisher()
        configureShowingResultsPublisher()
        configureIsLoadingPublisher()
    }
    
    private func configureSearchDebouncePublisher() {
        state.$query
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { self.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func configureShowingResultsPublisher() {
        state.$query
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isShowingResults, on: state)
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
            state.searchList = []
            return
        }
        searchService.search(for: query)
            .sink(receiveCompletion: { [weak self] _ in
                self?.state.isLoading = false
            },
            receiveValue: { [weak self] results in
                self?.state.searchList = results
            }).store(in: &cancelBag)
    }
}
