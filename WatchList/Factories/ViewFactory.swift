//
//  ViewFactory.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class ViewFactory {
    
    private var viewModelFactory: ViewModelFactory
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    func search() -> SearchView {
        return SearchView(viewModel: viewModelFactory.search())
    }
    
    static func create() -> ViewFactory {
        let dataAccessContainer = DataAccessContainer()
        let serviceContainer = ServiceContainer(dataAccessContainer: dataAccessContainer)
        let viewModelFactory = ViewModelFactory(serviceContainer: serviceContainer)
        return ViewFactory(viewModelFactory: viewModelFactory)
    }
}
