//
//  SearchViewPresenter.swift
//  WatchList
//
//  Created by davidb on 09/07/2020.
//

import Foundation
import Combine

protocol SearchViewPresenterProtocol {
    var viewModel: SearchViewModel { get }
    func search(query: String)
}

class SearchViewPresenter: SearchViewPresenterProtocol {
    
    var viewModel = SearchViewModel()
    
    @Published
    private var query: String = ""
    
    private var cancelBag = Set<AnyCancellable>()
    private var searchCancellable: AnyCancellable?
    private let searchService: SearchService
    private let viewModelFactory: ViewModelFactory
    
    init(searchService: SearchService, viewModelFactory: ViewModelFactory) {
        self.searchService = searchService
        self.viewModelFactory = viewModelFactory
        
        configureSearchDebouncePublisher()
    }
    
    func search(query: String) {
        self.query = query
        configureState()
    }
    
    private func configureState() {
        if query.count > 0 {
            viewModel.isLoading = true
        } else {
            viewModel.resultsState = .empty
            searchCancellable = nil
            viewModel.isLoading = false
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
            viewModel.isLoading = false
            return
        }
        searchCancellable = searchService.search(for: query)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.viewModel.isLoading = false
                if case .failure = completion {
                    self.viewModel.resultsState = .showingResults(SearchResultsViewModel(state: .error))
                }
            },
            receiveValue: { [weak self] results in
                guard let self = self else { return }
                if results.count > 0 {
                    let viewModels = results.map { (result) -> SearchItemViewModel in
                        return self.viewModelFactory.searchItem(result: result)
                    }
                    self.viewModel.resultsState = .showingResults(SearchResultsViewModel(state: .loaded(results: viewModels)))
                } else {
                    self.viewModel.resultsState = .showingResults(SearchResultsViewModel(state: .noResults))
                }
            })
    }
}
