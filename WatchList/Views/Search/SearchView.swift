//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @ObservedObject var viewModel: BindableSearchViewModel
    
    init(viewModel: BindableSearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.query, isLoading: $viewModel.isLoading)
                .padding(.top)
            if viewModel.isShowingResults {
                if viewModel.searchList.count > 0 {
                    Text("You searched for: \(viewModel.query)")
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.searchList, id: \.self) { result in
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
            SearchView(viewModel: viewModel)
        }
    }
    
    static var viewModel: BindableSearchViewModel {
        return BindableSearchViewModel(searchService: MockSearchService())
    }
    
    class MockSearchService: SearchService {
        func search(for query: String) -> AnyPublisher<[SearchResult], Error> {
            fatalError()
        }

    }
}

