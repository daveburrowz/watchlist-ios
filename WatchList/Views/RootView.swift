//
//  RootView.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import SwiftUI

struct RootView: View {
    
    private var viewFactory = ViewFactory.create()
    
    var body: some View {
        TabView {
            NavigationView {
                viewFactory.search()
            }.tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            ContentView(name: "Watch List")
            .tabItem {
                Image(systemName: "list.and.film")
                Text("Watch List")
            }
            ContentView(name: "Profile").tabItem {
                Image(systemName: "person.crop.circle")
                Text("Profile")
            }
        }.environmentObject(viewFactory)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
