//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel: AnyViewModel<SearchState>
    
    init(viewModel: AnyViewModel<SearchState>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.state.query, isLoading: $viewModel.state.isLoading)
                .padding(.top)
            if viewModel.state.isShowingResults {
                if viewModel.state.searchList.count > 0 {
                    Text("You searched for: \(viewModel.state.query)")
                    NavigationLink(
                        destination: LazyView(SearchView(viewModel: AnyViewModel(SearchViewModel()))),
                        label: {
                            Text("Navigate")
                        })
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.state.searchList, id: \.self) { result in
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
                Spacer()
            }
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView(viewModel: AnyViewModel(PreviewSearchViewModel()))
        }
    }
}

class PreviewSearchViewModel: ViewModel {
    @Published
    var state: SearchState = SearchState()
}
