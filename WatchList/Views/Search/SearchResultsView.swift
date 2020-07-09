//
//  SearchResultsView.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import SwiftUI

struct SearchResultsView: View {
    
    @EnvironmentObject private var viewFactory: ViewFactory
    private var viewModel: SearchResultsViewModel
    
    init(viewModel: SearchResultsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .loaded(let results):
                ScrollView {
                    LazyVStack {
                        ForEach(results, id: \.searchResult) { result in
                            NavigationLink(destination: LazyView(viewFactory.detail(result: result.searchResult))) {
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
        SearchResultsView(viewModel: SearchResultsViewModel(state: .noResults))
    }
}
