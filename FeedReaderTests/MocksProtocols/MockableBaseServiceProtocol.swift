//
//  MockableBaseServiceProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/04/2023.
//

import Foundation
import Combine

protocol MockableBaseServiceProtocol {
    typealias Mock = MockURLProtocol.MockedResponse
    var cancellable: AnyCancellable? { get }
    var mockRequestUrl: URLRequest { get }
}
