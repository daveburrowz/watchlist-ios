//
//  RootView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            ContentView(name: "Search").tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            ContentView(name: "Watch List").tabItem {
                Image(systemName: "list.and.film")
                Text("Watch List")
            }
            ContentView(name: "Profile").tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
