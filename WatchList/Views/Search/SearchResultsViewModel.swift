//
//  SearchResultsViewModel.swift
//  WatchList
//
//  Created by davidb on 09/07/2020.
//

import Foundation

struct SearchResultsViewModel {
    
    enum State {
        case loading
        case loaded(results: [SearchItemViewModel])
        case noResults
        case error
    }
    
    let state: State
}
