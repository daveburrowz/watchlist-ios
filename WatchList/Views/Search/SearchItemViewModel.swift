//
//  SearchItemViewModel.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

struct SearchItemViewModel {
    
    let title: String
    let year: String?
    let posterPresenter: PosterImagePresenterProtocol
    let searchResult: SearchResult
    
    init(searchResult: SearchResult, viewModelFactory: ViewModelFactory) {
        let posterPresenter = viewModelFactory.posterImage(tmbdId: searchResult.tmdbId, type: searchResult.type)
        let year = searchResult.year.map { (year) -> String in
            String(year)
        }
        title = searchResult.title
        self.year = year
        self.posterPresenter = posterPresenter
        self.searchResult = searchResult
    }
}

