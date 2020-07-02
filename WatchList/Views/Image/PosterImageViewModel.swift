//
//  PosterImageViewModel.swift
//  WatchList
//
//  Created by davidb on 02/07/2020.
//

import Foundation
import Combine

enum PosterImageViewModelViewState {
    case noImage
    case loaded
}

struct PosterImageViewModelState {
    var viewState = PosterImageViewModelViewState.noImage
}

enum PosterImageViewModelInput {
    case didAppear
}

class PosterImageViewModel: ViewModel {
    
    @Published
    var state = PosterImageViewModelState()
    
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
    
    func trigger(_ input: PosterImageViewModelInput) {
        switch input {
        case .didAppear:
            didAppear()
        }
    }
    
    private func didAppear() {
        guard let tmbdId = tmbdId, hasAppeared == false else { return }
        hasAppeared = true
        imageCancellable = imageUrlService.url(tmbdId: tmbdId, type: type)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    print("failed \(tmbdId) \(error)")
                    self.state.viewState = .noImage
                }
            },
            receiveValue: { [weak self] result in
                guard let self = self else { return }
                print("loaded \(tmbdId)")
                self.state.viewState = .loaded
            })

    }
}
