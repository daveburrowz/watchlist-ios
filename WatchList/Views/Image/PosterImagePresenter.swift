//
//  PosterImagePresenter.swift
//  WatchList
//
//  Created by davidb on 08/07/2020.
//

import Foundation
import Combine

class PresenterPosterImageViewModel: ObservableObject {
  enum State {
    case noImage
    case loaded(URL)
  }
  
  @Published var state: State = .noImage
}

extension PresenterPosterImageViewModel: PosterImagePresenterDelegate {
    func noImage() {
        state = .noImage
    }
    
    func loaded(_ url: URL) {
        state = .loaded(url)
    }
}

protocol PosterImagePresenterProtocol: class {
    var delegate: PosterImagePresenterDelegate? { get set }
    func load()
}

protocol PosterImagePresenterDelegate: class {
    func noImage()
    func loaded(_ url: URL)
}

class PosterImagePresenter: PosterImagePresenterProtocol {
    
    weak var delegate: PosterImagePresenterDelegate?
    
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
                    self.delegate?.noImage()
                }
            },
            receiveValue: { [weak self] url in
                guard let self = self else { return }
                self.delegate?.loaded(url)
            })
    }
}
