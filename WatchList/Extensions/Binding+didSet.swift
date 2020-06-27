//
//  Binding+didSet.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

extension Binding {
    func didSet(execute: @escaping (Value) ->Void) -> Binding {
        return Binding(
            get: {
                return self.wrappedValue
            },
            set: {
                execute($0)
                self.wrappedValue = $0
            }
        )
    }
}
