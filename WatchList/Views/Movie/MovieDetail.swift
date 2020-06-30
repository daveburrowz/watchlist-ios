//
//  MovieDetail.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import SwiftUI

struct MovieDetail: View {
    
    private let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    var body: some View {
        VStack {
            Text("Movie").font(.largeTitle)
            Text(movie.title)
        }
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetail(movie: ModelPreview.movie())
    }
}
