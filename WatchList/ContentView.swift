//
//  ContentView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct ContentView: View {
    
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    var body: some View {
        Text(name).padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(name: "name")
    }
}
