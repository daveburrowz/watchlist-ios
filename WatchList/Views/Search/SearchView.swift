//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    private var presenter: SearchViewPresenterProtocol
    
    @EnvironmentObject var viewFactory: ViewFactory
    @ObservedObject private var viewModel: SearchViewModel
    @State private var query = ""
    
    init(presenter: SearchViewPresenterProtocol) {
        self.viewModel = presenter.viewModel
        self.presenter = presenter
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $query.didSet(execute: { presenter.search(query: $0) }), isLoading: viewModel.isLoading)
                .padding(.top)
            switch viewModel.resultsState {
            case .empty:
                Spacer()
                Text("Enter Search")
                Spacer()
            case .showingResults(let viewModel):
                SearchResultsView(viewModel: viewModel)
            }
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(presenter: PreviewSearchViewPresenter())
        }
    }
    
    class PreviewSearchViewPresenter : SearchViewPresenterProtocol {
        var viewModel = SearchViewModel()
        
        func search(query: String) {
        }
    }
}
