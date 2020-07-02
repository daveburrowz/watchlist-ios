//
//  TMDBImageView.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import SwiftUI

struct PosterImageView: View {
    
    @ObservedObject private var viewModel: AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput>

    init(viewModel: AnyViewModel<PosterImageViewModelState, PosterImageViewModelInput>) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            switch viewModel.state.viewState {
            case .noImage:
                Image("matrix").resizable()
            case .loaded:
                Text("Loaded")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.red)
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
