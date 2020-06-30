//
//  ShowDetail.swift
//  WatchList
//
//  Created by davidb on 30/06/2020.
//

import SwiftUI

struct ShowDetail: View {
    private let show: Show
    
    init(show: Show) {
        self.show = show
    }
    
    var body: some View {
        VStack {
            Text("Show").font(.largeTitle)
            Text(show.title)
        }
    }
}

struct ShowDetail_Previews: PreviewProvider {
    static var previews: some View {
        ShowDetail(show: ModelPreview.show())
    }
}
