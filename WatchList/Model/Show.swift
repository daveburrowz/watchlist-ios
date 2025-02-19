//
//  Show.swift
//  WatchList
//
//  Created by David Burrows on 28/06/2020.
//

import Foundation

struct Show: Decodable, Equatable, Hashable  {
    let ids: Ids
    let title: String
    let year: Int?
}
