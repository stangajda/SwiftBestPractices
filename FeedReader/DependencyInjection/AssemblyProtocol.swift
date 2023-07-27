//
//  AssemblyProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Swinject

protocol AssemblyProtocol: Assembly {
}

protocol AssemblyNameProtocol: Assembly {
}

//MARK:- Register
extension AssemblyNameProtocol {
    func register<Service>(_ serviceType: Service.Type, container: Container, name: Injection.Name, _ factory: @escaping (Resolver) -> Service ){
        container.register(serviceType, name: name.rawValue, factory: factory)
    }
    
    func register<Service, Arg>(_ serviceType: Service.Type, container: Container, _ factory: @escaping (Resolver, Arg) -> Service ){
        container.register(serviceType, factory: factory)
    }
}
