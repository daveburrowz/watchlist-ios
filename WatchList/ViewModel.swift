//
//  ViewModel.swift
//  WatchList
//
//  Created by David Burrows on 27/06/2020.
//

import Combine
import Foundation

protocol ViewModel: ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    associatedtype State: ObservableObject

    var state: State { get set }
}

extension AnyViewModel: Identifiable where State: Identifiable {
    var id: State.ID {
        state.id
    }
}

final class AnyViewModel<State: ObservableObject>: ViewModel {

    private var anyCancellable: AnyCancellable? = nil

    var state: State

    // MARK: Initialization
    init<V: ViewModel>(_ viewModel: V) where V.State == State {

        self.state = viewModel.state
        anyCancellable = state.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }

}

