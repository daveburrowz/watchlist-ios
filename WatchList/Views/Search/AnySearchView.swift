//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI
import Combine

struct AnySearchView: View {
    
    @EnvironmentObject var viewFactory: ViewFactory
    @ObservedObject private var viewModel: AnyViewModel<AnySearchViewModelState, AnySearchInput>
    private var state: AnySearchViewModelState {
        return viewModel.state
    }
    var count = RenderCount()
    @State private var query = ""
    
    init(viewModel: AnyViewModel<AnySearchViewModelState, AnySearchInput>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        count.count = count.count + 1
        return VStack {
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
            AnySearchView(viewModel: viewModel)
        }
    }
    
    static var viewModel: AnyViewModel<AnySearchViewModelState, AnySearchInput> {
        return AnyViewModel(PreviewAnySearchViewModel())
    }
    
    class PreviewAnySearchViewModel: ViewModel {
     
        @Published
        var state: AnySearchViewModelState = AnySearchViewModelState()


        func trigger(_ input: AnySearchInput) {

        }
    }
}
