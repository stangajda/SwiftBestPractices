//
//  DIInjection.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

public protocol InjectionRegistering {
    static var shared: Self { get }
    var container: Container { get }
    func initialRegistration()
}

// MARK:- Injection
public final class Injection: InjectionRegistering  {
    public static let shared = Injection()
    public let container = Container()
    lazy var assembler = Assembler()
}
