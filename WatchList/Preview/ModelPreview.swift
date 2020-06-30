//
//  ModelPreview.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import Foundation

class ModelPreview {
    
    static func movieSearchResult() -> SearchResult {
        return SearchResult.movie(Self.movie())
    }
    
    static func movie() -> Movie {
        let ids = Ids(trakt: 0, tmdb: 0)
        return Movie(ids: ids, title: "The matrix")
    }
    
    static func show() -> Show {
        let ids = Ids(trakt: 0, tmdb: 0)
        return Show(ids: ids, title: "Game of thrones")
    }
}
