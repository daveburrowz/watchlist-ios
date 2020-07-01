//
//  SearchResult.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation

enum SearchResult: Decodable, Equatable, Hashable  {
    
    case movie(Movie)
    case show(Show)
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(String.self, forKey: .type) {
        case Types.movie.rawValue: self = .movie(try container.decode(Movie.self, forKey: .movie))
        case Types.show.rawValue: self = .show(try container.decode(Show.self, forKey: .show))
        default: self = .unknown
        }
    }
    
    private enum Types: String {
        case movie
        case show
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case movie
        case show
    }
    
    var title: String {
        switch self {
        case .movie(let movie):
            return movie.title
        case .show(let show):
            return show.title
        case .unknown:
            fatalError("Should never happen")
        }
    }
    
    var year: Int? {
        switch self {
        case .movie(let movie):
            return movie.year
        case .show(let show):
            return show.year
        case .unknown:
            fatalError("Should never happen")
        }
    }
}
