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
    
    private var cancelBag = Set<AnyCancellable>()
    private var repo = NetworkSearchRepository(httpClient: FoundationHTTPClient())

    
    init() {
        configureDebouncePublisher()
    }
    
    private func configureDebouncePublisher() {
        $query
            .removeDuplicates()
            .debounce(for: 2.0, scheduler: RunLoop.main)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { self.search(for: $0)})
            .store(in: &cancelBag)
    }
    
    private func search(for query: String) {
        guard query.count > 0 else {
            searchList = []
            return
        }
        repo.search(for: query)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] in
                    self?.searchList = $0
                  }).store(in: &cancelBag)
    }
}
