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
    private var viewModel: SearchViewModel
    @ObservedObject private var state: SearchViewModelState
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.state = viewModel.state
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $state.query, isLoading: state.isLoading)
                .padding(.top)
            switch state.resultsState {
            case .empty:
                Spacer()
                if state.isLoading {
                    ProgressView()
                } else {
                    Text("Enter Search")
                }
                Spacer()
            case .loaded(let results):
                ScrollView {
                    VStack {
                        ForEach(results, id: \.self) { result in
                            NavigationLink(destination: LazyView(viewFactory.detail(result: result))) {
                                SearchItemView(result: result).padding(.horizontal)
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }.padding(.bottom)
                }
            case .noResults:
                Spacer()
                Text("No Results")
                Spacer()
            case .error:
                Spacer()
                Text("Something went wrong :(")
                Spacer()
            }
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(viewModel: viewModel)
        }
    }
    
    static var viewModel: SearchViewModel {
        return PreviewSearchViewModel(results: [ModelPreview.movieSearchResult()])
    }
    
    class PreviewSearchViewModel: SearchViewModel {
        
        @Published
        var state: SearchViewModelState = SearchViewModelState()
        
        init(results: [SearchResult]) {
            state.resultsState = .loaded(results: results)
        }
        
        func didTapButton() {
            
        }
    }
}

