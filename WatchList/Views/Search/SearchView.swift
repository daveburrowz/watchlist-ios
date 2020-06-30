//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel = SearchViewModel()
    @State var query = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $query.didSet(execute: { (query) in
                viewModel.trigger(.search(for: query))
            }), isLoading: $viewModel.state.isLoading)
                .padding(.top)
            content
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var empty: some View {
        Group {
            Spacer()
            Text("Enter Search")
            Spacer()
        }
    }
    
    private var loading: some View {
        Group {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    private func loaded(searchResults: [SearchResult]) -> some View {
        Group {
            Text("You searched for: \(query)")
            ScrollView {
                LazyVStack {
                    ForEach(searchResults, id: \.self) { result in
                        Text("\(result.title)")
                    }
                }.padding(.bottom)
            }
        }
    }
    
    private var content: some View {
        switch viewModel.state.state {
            case .empty:
                return viewModel.state.isLoading ? AnyView(loading) : AnyView(empty)
            case .loaded(let searchResults):
                return AnyView(loaded(searchResults: searchResults))
            }
        }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
