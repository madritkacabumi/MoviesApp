//
//  Publisher+Util+Extensions.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import Foundation
import Combine

public typealias Trigger<T> = PassthroughSubject<T, Never>

// MARK: - DisposeBag
class DisposeBag {
    
    var subscriptions = Set<AnyCancellable>()
    
    func clear() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

// MARK: - AnyCancellable
extension AnyCancellable {
    
    func store(in disposeBag: DisposeBag) {
        disposeBag.subscriptions.insert(self)
    }
}

// MARK: - Trigger
extension Trigger {
    
    func fire(value: Output) {
        self.send(value)
    }
}

extension Trigger where Output == Void {
    
    func fire() {
        self.fire(value: ())
    }
}

// MARK: - Publisher
extension Publisher {
    
    public func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
    
    func handleValue(callback: @escaping ( _ data: Output) -> Void) -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveOutput: { output in
            callback(output)
        })
    }
    
    func handleError(callback: @escaping ( _ error: Failure) -> Void) -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                callback(error)
            }
        })
    }
}
