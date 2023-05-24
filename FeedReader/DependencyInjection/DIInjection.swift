//
//  DIInjection.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

public protocol InjectionRegistering {
    func initialRegistration()
}

public final class Injection: InjectionRegistering  {
    static let shared = Injection()
    let container = Container()
    lazy var assembler = Assembler()
    
    private init() {
        initialRegistration()
    }
}
