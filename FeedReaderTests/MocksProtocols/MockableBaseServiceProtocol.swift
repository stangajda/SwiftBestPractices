//
//  MockableBaseServiceProtocol.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 27/04/2023.
//

import Foundation
import Combine
import Nimble

protocol MockableBaseServiceProtocol {
    typealias Mock = MockURLProtocol.MockedResponse
    var cancellable: AnyCancellable? { get }
    var mockRequestUrl: URLRequest { get }
}

extension MockableBaseServiceProtocol {
    func setUpSpec() {
        DependencyManager.shared.registerMockURLSession()
        Nimble.PollingDefaults.timeout = .seconds(5)
    }
    
    func mockResponse(result: Result<Data, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func mockResponse<T:Encodable> (result: Result<T, Swift.Error>, apiCode: APICode = 200) {
        do {
            MockURLProtocol.mock = try Mock(request: mockRequestUrl, result: result, apiCode: apiCode)
        } catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func checkResponse(done: @escaping() -> Void, closure: @escaping (Result<Data, Swift.Error>) -> Void) -> AnyCancellable? {
        var cancellable: AnyCancellable?
        cancellable = Service().fetchData(mockRequestUrl)
            .sinkToResult({ result in
                closure(result)
                done()
            })
        return cancellable
     
    }

}


