//
//  SearchView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct SearchView: View {
    
    @State var search: String = ""
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        VStack {
            SearchBar(text: $search.didSet(execute: { (term) in
                viewModel.trigger(.search(for: term))
            })).padding(.top)
            if viewModel.state.searchList.count > 0 {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.state.searchList, id: \.self) { result in
                            Text("\(result.title)")
                        }
                    }.padding(.bottom)
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
            SearchView()
        }
    }
}
