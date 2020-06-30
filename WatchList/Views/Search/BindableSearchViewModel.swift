//
//  BindableSearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation
import Combine


class BindableSearchViewModel: ObservableObject {
    
    @Published var searchList: [SearchResult] = []
    @Published var query = ""
    @Published var isLoading = false
    @Published var isShowingResults = false
    
    private var cancelBag = Set<AnyCancellable>()
    private let searchService: SearchService
    
    
    init(searchService: SearchService) {
        self.searchService = searchService
        
        configureSearchDebouncePublisher()
        configureShowingResultsPublisher()
        configureIsLoadingPublisher()
    }
    
    private func configureSearchDebouncePublisher() {
        $query
            .removeDuplicates()
            .debounce(for: 1, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { self.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func configureShowingResultsPublisher() {
        $query
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isShowingResults, on: self)
            .store(in: &cancelBag)
    }
    
    private func configureIsLoadingPublisher() {
        $query
            .receive(on: RunLoop.main)
            .map({ $0.count > 0 })
            .assign(to: \.isLoading, on: self)
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        isLoading = true
        guard query.count > 0 else {
            isLoading = false
            searchList = []
            return
        }
        searchService.search(for: query)
            .sink(receiveCompletion: { [weak self] _ in
                self?.isLoading = false
            },
            receiveValue: { [weak self] results in
                self?.searchList = results
            }).store(in: &cancelBag)
    }
}
