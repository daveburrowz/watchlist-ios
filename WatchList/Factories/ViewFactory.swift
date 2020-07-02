//
//  ViewFactory.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation
import SwiftUI

class ViewFactory: ObservableObject  {
    
    private var viewModelFactory: ViewModelFactory
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    func search() -> SearchView {
        return SearchView(viewModel: viewModelFactory.search())
    }
    
    func detail(result: SearchResult) -> AnyView {
        switch result {
        case .movie(let movie):
            return AnyView(MovieDetail(movie: movie))
        case .show(let show):
            return AnyView(ShowDetail(show: show))
        case .unknown:
            fatalError()
        }
    }
    
    func posterImage(viewModel: AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput>) -> PosterImageView {
        return PosterImageView(viewModel: viewModel)
    }
    
    static func create() -> ViewFactory {
        let dataAccessContainer = DataAccessContainer()
        let serviceContainer = ServiceContainer(dataAccessContainer: dataAccessContainer)
        let viewModelFactory = ViewModelFactory(serviceContainer: serviceContainer)
        return ViewFactory(viewModelFactory: viewModelFactory)
    }
}
