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
        Text(result.title)
            .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .center)
            .border(Color.black, width: 1)
            .padding(.all, 10)
    }
}

struct SearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        let ids = Ids(trakt: 0, tmdb: 0)
        let movie = Movie(ids: ids, title: "The matrix")
        return SearchItemView(result: SearchResult.movie(movie))
    }
}
