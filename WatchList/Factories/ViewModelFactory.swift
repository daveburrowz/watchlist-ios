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
    
    func search() -> SearchViewPresenter {
        return SearchViewPresenter(searchService: serviceContainer.searchService, viewModelFactory: self)
    }
    
    func searchItem(result: SearchResult) -> SearchItemViewModel {
        return SearchItemViewModel(searchResult: result, viewModelFactory: self)
    }
    
    func posterImage(tmbdId: Int?, type: MediaType) -> PosterImagePresenterProtocol {
        return PosterImagePresenter(tmbdId: tmbdId, type: type, imageUrlService: serviceContainer.imageUrlService)
    }
}
