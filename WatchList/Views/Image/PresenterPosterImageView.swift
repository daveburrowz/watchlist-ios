//
//  PresenterPosterImageView.swift
//  WatchList
//
//  Created by davidb on 08/07/2020.
//

import SwiftUI
import KingfisherSwiftUI

struct PresenterPosterImageView: View {
    
    @ObservedObject private var viewModel: PresenterPosterImageViewModel
    private let presenter: PosterImagePresenterProtocol

    init(presenter: PosterImagePresenterProtocol) {
        self.viewModel = presenter.viewModel
        self.presenter = presenter
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .noImage:
                Image("no-poster").resizable()
            case .loaded(let url):
                KFImage(url).resizable().placeholder {
                    Image("no-poster").resizable()
                }
            }
        }.onAppear {
            presenter.load()
        }
    }
}

struct PresenterPosterImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PosterImageView(viewModel: AnyViewModel(PreviewPosterImageViewModel()))
            PosterImageView(viewModel: AnyViewModel(PreviewPosterImageViewModel()))
        }.previewLayout(.fixed(width: 100, height: 150))
    }
}
