//
//  Config.swift
//  FeedReaderTests
//
//  Created by Stan Gajda on 23/05/2023.
//

import Foundation
import Quick
import Nimble

class PollingConfiguration: QuickConfiguration {
    override class func configure(_ configuration: QCKConfiguration) {
        TestInjection.shared.setupTestURLSession()
        Nimble.PollingDefaults.timeout = .seconds(5)
        Nimble.PollingDefaults.pollInterval = .milliseconds(100)
    }
}

extension URLSession {
    static func mockURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        configuration.timeoutIntervalForRequest = 1
        configuration.timeoutIntervalForResource = 1
        configuration.waitsForConnectivity = false
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.httpCookieStorage = nil
        configuration.urlCredentialStorage = nil
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        configuration.networkServiceType = .responsiveData
        configuration.allowsCellularAccess = true
        configuration.isDiscretionary = false
        configuration.shouldUseExtendedBackgroundIdleMode = false
        configuration.urlCredentialStorage = nil
        return URLSession(configuration: configuration)
    }
}
