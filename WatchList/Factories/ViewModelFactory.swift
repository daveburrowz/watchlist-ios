//
//  ViewModelFactory.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class ViewModelFactory {
    
    private var serviceContainer: ServiceContainer
    
    init(serviceContainer: ServiceContainer) {
        self.serviceContainer = serviceContainer
    }
    
    func search() -> AnyViewModel<SearchViewModelState, SearchInput> {
        return AnyViewModel(SearchViewModel(searchService: serviceContainer.searchService, viewModelFactory: self))
    }
    
    func searchItem(result: SearchResult) -> AnyViewModel<SearchItemViewModelState, Never> {
        return AnyViewModel(SearchItemViewModel(searchResult: result, viewModelFactory: self))
    }
    
    func posterImage(tmbdId: Int?, type: MediaType) -> AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput> {
        return AnyViewModel(PosterImageViewModel(tmbdId: tmbdId, type: type, imageUrlService: serviceContainer.imageUrlService))
    }
}
