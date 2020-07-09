//
//  PosterImagePresenter.swift
//  WatchList
//
//  Created by davidb on 08/07/2020.
//

import Foundation
import Combine

class PosterImageViewModel: ObservableObject {
  enum State {
    case noImage
    case loaded(URL)
  }
  
  @Published var state: State = .noImage
}

protocol PosterImagePresenterProtocol {
    var viewModel: PosterImageViewModel { get }
    func load()
}

class PosterImagePresenter: PosterImagePresenterProtocol {
    
    private(set) var viewModel =  PosterImageViewModel()
    
    private let imageUrlService: ImageUrlService
    private var imageCancellable: AnyCancellable?
    private let tmbdId: Int?
    private let type: MediaType
    private var hasAppeared: Bool = false
    
    init(tmbdId: Int?, type: MediaType, imageUrlService: ImageUrlService) {
        self.tmbdId = tmbdId
        self.type = type
        self.imageUrlService = imageUrlService
    }
    
    func load() {
        guard let tmbdId = tmbdId, hasAppeared == false else { return }
        hasAppeared = true
        imageCancellable = imageUrlService.url(tmbdId: tmbdId, type: type)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure = completion {
                    self.viewModel.state = .noImage
                }
            },
            receiveValue: { [weak self] url in
                guard let self = self else { return }
                self.viewModel.state = .loaded(url)
            })
    }
}
