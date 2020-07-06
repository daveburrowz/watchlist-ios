//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @EnvironmentObject var viewFactory: ViewFactory
    @ObservedObject private var viewModel: AnySearchViewModel
    private var state: SearchViewModelState {
        return viewModel.state
    }
    
    @State private var query = ""
    
    init(viewModel: AnySearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $query.didSet(execute: { viewModel.trigger(.search(query: $0)) }), isLoading: state.isLoading)
                .padding(.top)
            switch state.resultsState {
            case .empty:
                Spacer()
                Text("Enter Search")
                Spacer()
            case .showingResults(let state):
                SearchResultsView(state: state)
            }
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AnySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(viewModel: viewModel)
        }
    }
    
    static var viewModel: AnySearchViewModel {
        return AnyViewModel(PreviewAnySearchViewModel())
    }
    
    class PreviewAnySearchViewModel: ViewModel {
        
        @Published
        var state: SearchViewModelState = SearchViewModelState()
        
        
        func trigger(_ input: SearchInput) {
            
        }
    }
}
