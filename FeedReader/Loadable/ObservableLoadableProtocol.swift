//
//  ObservableLoadableProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 03/05/2023.
//

import Foundation
import Combine

protocol ObservableLoadableProtocol: ObservableObject, LoadableProtocol {
    var state: LoadableEnums<Self.T, Self.U>.State { get set }
}

extension ObservableLoadableProtocol {
    func assignNoRetain<Root: AnyObject>(_ self: Root, to keyPath: ReferenceWritableKeyPath<Root, State>) -> AnyCancellable {
        publishersSystem(state)
                .assignNoRetain(to: keyPath, on: self)
    }
}
