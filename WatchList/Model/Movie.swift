//
//  Movie.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation

struct Movie: Decodable, Equatable, Hashable  {
    var ids: Ids
    var title: String
}
