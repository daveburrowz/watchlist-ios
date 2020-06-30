//
//  LazyView.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import SwiftUI

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
