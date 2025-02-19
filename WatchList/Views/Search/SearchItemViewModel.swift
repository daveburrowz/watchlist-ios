//
//  SearchItemViewModel.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

struct SearchItemViewModelState {
    let title: String
    let year: String?
    let posterViewModel: AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput>
    let searchResult: SearchResult
}

class SearchItemViewModel: ViewModel {
    
    @Published
    var state: SearchItemViewModelState
    
    init(searchResult: SearchResult, viewModelFactory: ViewModelFactory) {
        let posterViewModel = viewModelFactory.posterImage(tmbdId: searchResult.tmdbId, type: searchResult.type)
        let year = searchResult.year.map { (year) -> String in
            String(year)
        } 
        state = SearchItemViewModelState(title: searchResult.title, year: year, posterViewModel: posterViewModel, searchResult: searchResult)
    }
    
    func trigger(_ input: Never) {

    }
}

