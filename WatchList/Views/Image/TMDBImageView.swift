//
//  TMDBImageView.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import SwiftUI

struct TMDBImageView: View {
    
    var tmdbId: Int?
    
    init(tmdbId: Int?) {
        self.tmdbId = tmdbId
    }
    
    var body: some View {
        Group {
            if let tmdbId = tmdbId {
                Text("\(tmdbId)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
            } else {
                Image("matrix")
                    .resizable()
            }
        }
    }
}

struct TMDBImageView_Previews: PreviewProvider {
    static var previews: some View {
        TMDBImageView(tmdbId: 0)
    }
}
