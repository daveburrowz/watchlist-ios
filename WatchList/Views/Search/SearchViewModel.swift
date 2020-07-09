//
//  SearchViewModel.swift
//  WatchList
//
//  Created by davidb on 09/07/2020.
//

import Foundation

enum SearchViewModelResultsState {
    case empty
    case showingResults(SearchResultsViewModel)
}

class SearchViewModel: ObservableObject {
    
    @Published
    var isLoading = false {
        didSet {
            guard case .empty = resultsState, isLoading == true else {
                return
            }
            resultsState = SearchViewModelResultsState.showingResults(SearchResultsViewModel(state: .loading))
        }
    }
    
    var resultsState  = SearchViewModelResultsState.empty
}
