//
//  BindableSearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation
import Combine


class BindableSearchViewModel: ObservableObject {
    
    enum State {
        case empty
        case loading
        case loaded(searchList: [SearchResult])
    }
    
    @Published var query = ""
    
    @Published var state: State = .empty
    
    private var cancelBag = Set<AnyCancellable>()
    private var repo = NetworkSearchRepository(httpClient: FoundationHTTPClient())
    
    
    init() {
        configureSearchDebouncePublisher()
        configureShowingResultsPublisher()
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
            .map({ $0.count > 0 ? .loading : .empty })
            .assign(to: \.state, on: self)
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            state = .empty
            return
        }
        repo.search(for: query)
            .sink(receiveCompletion: {  _ in
            },
            receiveValue: { [weak self] results in
                self?.state = .loaded(searchList: results)
            }).store(in: &cancelBag)
    }
}
