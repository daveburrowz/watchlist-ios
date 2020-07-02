//
//  SearchItemView.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import SwiftUI

struct SearchItemView: View {
    
    private let result: SearchResult
    
    init(result: SearchResult) {
        self.result = result
    }
    
    var body: some View {
        HStack {
            TMDBImageView(tmdbId: result.tmdbId)
                .aspectRatio(0.66, contentMode: .fit)
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(result.title)
                result.year.map( { Text("\(String($0))") })
            }
            Spacer()
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .leading)
        .padding(.bottom, 8)
        .contentShape(Rectangle())
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        return SearchItemView(result: ModelPreview.movieSearchResult()).previewLayout(.fixed(width: 375, height: 150))
    }
}
