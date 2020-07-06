//
//  ViewModelFactory.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

typealias AnySearchViewModel = AnyViewModel<SearchViewModelState, SearchInput>
typealias AnySearchItemViewModel = AnyViewModel<SearchItemViewModelState, Never>
typealias AnyPosterImageViewModel = AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput>

class ViewModelFactory {
    
    private var serviceContainer: ServiceContainer
    
    init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer
    }
    
    func search() -> AnySearchViewModel {
        return AnyViewModel(SearchViewModel(searchService: serviceContainer.searchService, viewModelFactory: self))
    }
    
    func searchItem(result: SearchResult) -> AnySearchItemViewModel {
        return AnyViewModel(SearchItemViewModel(searchResult: result, viewModelFactory: self))
    }
    
    func posterImage(tmbdId: Int?, type: MediaType) -> AnyPosterImageViewModel {
        return AnyViewModel(PosterImageViewModel(tmbdId: tmbdId, type: type, imageUrlService: serviceContainer.imageUrlService))
    }
}
