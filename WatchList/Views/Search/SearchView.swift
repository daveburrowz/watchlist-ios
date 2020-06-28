//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel = BindableSearchViewModel()
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.query)
                .padding(.top)

            switch viewModel.state {
            case .empty:
                 empty
            case .loading:
                 loading
            case .loaded(let results):
                 loaded(results: results)
            }
        }.navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var empty: some View {
        Group {
            Spacer()
            Text("Enter Search")
            Spacer()
        }
    }
    
    var loading: some View {
        Group {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    func loaded(results: [SearchResult]) -> some View {
        Group {
            Text("You searched for: \(viewModel.query)")
            ScrollView {
                LazyVStack {
                    ForEach(results, id: \.self) { result in
                        Text("\(result.title)")
                    }
                }.padding(.bottom)
            }
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
