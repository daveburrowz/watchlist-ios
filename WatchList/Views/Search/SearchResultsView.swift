//
//  SearchResultsView.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import SwiftUI

struct SearchResultsView: View {
    
    @EnvironmentObject private var viewFactory: ViewFactory
    private var state: SearchResultsState
    
    init(state: SearchResultsState) {
        self.state = state
    }
    
    var body: some View {
        Group {
            switch state {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .loaded(let results):
                ScrollView {
                    LazyVStack {
                        ForEach(results, id: \.state.searchResult) { result in
                            NavigationLink(destination: LazyView(viewFactory.detail(result: result.state.searchResult))) {
                                SearchItemView(viewModel: result).padding(.horizontal)
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
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(state: SearchResultsState.loading)
    }
}
