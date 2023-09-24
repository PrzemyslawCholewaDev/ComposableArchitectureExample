//
//  MockURLSession.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 24/09/2023.
//

import Foundation

class MockURLProtocol: URLProtocol {

    static var mockJSON: String = ""

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        do {
            guard
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            else {
                throw APIClientError.requestBuildError
            }
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            if
                let data = Self.mockJSON.data(using: .utf8)
            {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}
