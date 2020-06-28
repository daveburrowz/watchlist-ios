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
