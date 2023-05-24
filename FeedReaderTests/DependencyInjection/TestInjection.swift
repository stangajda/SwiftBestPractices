//
//  TestInjection.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation

public final class TestInjection {
    static let shared = TestInjection()
    var assembler = Injection.shared.assembler
}
