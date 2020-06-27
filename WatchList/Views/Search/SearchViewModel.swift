//
//  SearchViewModel.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import Foundation

struct SearchState {
    var searchList: [String]
}

enum SearchStateInput {
    case search(for: String)
    case nextPage(for: String)
}

class SearchViewModel: ViewModel {

    @Published
    var state: SearchState

    init() {
        state = SearchState(searchList: [])
    }

    func trigger(_ input: SearchStateInput) {
        switch input {
        case .search(let term):
            search(for: term)
        case .nextPage(let term):
            page(for: term)
        }
    }

    fileprivate func search(for term: String) {
        guard term.count > 0 else {
            state = SearchState(searchList: [])
            return
        }
        var strings = [String]()
        for i in 1...100 {
            let string = "\(term) \(i)"
            strings.append(string)
        }
        state = SearchState(searchList: strings)
    }
    
    fileprivate func page(for term: String) {
        var strings = state.searchList
        for i in strings.count...strings.count+100 {
            let string = "\(term) \(i)"
            strings.append(string)
        }
        state = SearchState(searchList: strings)
    }
}
