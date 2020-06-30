//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI
import Combine

struct SearchView: View {
    
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
                    Text("You searched for: \(state.query)")
                    ScrollView {
                        LazyVStack {
                            ForEach(state.searchList, id: \.self) { result in
                                Text("\(result.title)")
                            }
                        }.padding(.bottom)
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                Spacer()
                Text("Enter Search")
                Button(action: {
                    viewModel.didTapButton()
                }, label: {
                    Text("Search for matrix")
                })
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
        return PreviewSearchViewModel()
    }
    
    class PreviewSearchViewModel: SearchViewModel {
       
        @Published
        var state: SearchViewModelState = SearchViewModelState()
        
        var statePublished: Published<SearchViewModelState> {
            _state
        }
        
        var statePublisher: Published<SearchViewModelState>.Publisher {
            $state
        }
        
        func didTapButton() {
            
        }
    }
}

