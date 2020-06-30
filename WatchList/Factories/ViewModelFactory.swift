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
    
    func search() -> BindableSearchViewModel {
        return BindableSearchViewModel(searchService: serviceContainer.searchService)
    }
}
