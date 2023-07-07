//
//  MockableServiceProtocol.swift
//  FeedReader
//
//  Created by Stan Gajda on 24/05/2023.
//

import Foundation
import Combine

protocol MockableServiceProtocol: MockableBaseServiceProtocol {
    typealias Mock = MockURLProtocol.MockedResponse
    static var mockManager: ServiceProtocol { get }
    static var cancellable: AnyCancellable? { get set }
    static var mockRequestUrl: URLRequest { get }
}

extension MockableServiceProtocol {
    func mockResponse(result: Result<Data, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: Self.mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func mockResponse<T:Encodable> (result: Result<T, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: Self.mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func fetchData(done: @escaping() -> Void, closure: @escaping (Result<Data, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = Self.mockManager.fetchData(Self.mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
     
    }

}
