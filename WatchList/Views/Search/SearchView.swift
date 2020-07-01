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
            SearchBar(text: $state.query, isLoading: $state.isLoading)
                .padding(.top)
            if state.isShowingResults {
                if state.searchList.count > 0 {
                    ScrollView {
                        VStack {
                            ForEach(state.searchList, id: \.self) { result in
                                NavigationLink(destination: LazyView(viewFactory.detail(result: result))) {
                                    SearchItemView(result: result)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }.padding(.bottom)
                    }.padding(.horizontal)
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                Spacer()
                Text("Enter Search")
                Spacer()
                LazyView(Spacer())
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
            state.isShowingResults = true
            state.searchList = results
        }
        
        func didTapButton() {
            
        }
    }
}

