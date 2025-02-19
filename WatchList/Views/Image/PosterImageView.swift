//
//  TMDBImageView.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import SwiftUI
import KingfisherSwiftUI

struct PosterImageView: View {
    
    @ObservedObject private var viewModel: AnyPosterImageViewModel

    init(viewModel: AnyPosterImageViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state.viewState {
            case .noImage:
                Image("no-poster").resizable()
            case .loaded(let url):
                KFImage(url).resizable().placeholder {
                    Image("no-poster").resizable()
                }
            }
        }.onAppear {
            viewModel.trigger(.didAppear)
        }
    }
}

struct PosterImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PosterImageView(viewModel: AnyViewModel(PreviewPosterImageViewModel()))
            PosterImageView(viewModel: AnyViewModel(PreviewPosterImageViewModel()))
        }.previewLayout(.fixed(width: 100, height: 150))
    }
}

class PreviewPosterImageViewModel: ViewModel {
    
    @Published
    var state = PosterImageViewModelState()
    
    
    func trigger(_ input: PosterImageViewModelInput) {
        
    }
}
