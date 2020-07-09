//
//  PosterImageViewModel.swift
//  WatchList
//
//  Created by davidb on 09/07/2020.
//

import Foundation

class PosterImageViewModel: ObservableObject {
  enum State {
    case noImage
    case loaded(URL)
  }
  
  @Published var state: State = .noImage
}
