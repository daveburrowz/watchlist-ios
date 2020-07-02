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
    
    func search() -> SearchViewModel {
        return SearchViewModelImpl(searchService: serviceContainer.searchService)
    }
    
    func anySearch() -> AnyViewModel<AnySearchViewModelState, AnySearchInput> {
        return AnyViewModel(AnySearchViewModel(searchService: serviceContainer.searchService))
    }
}
