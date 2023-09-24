//
//  APIRequest.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation
import Dependencies

public enum APIRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case options = "OPTIONS"
    case delete = "DELETE"
}

/// Enum defining which base URL to use in this request
public enum APIBaseUrl {
    case mainApi, functions, external, custom(path: String)
}

public protocol APIRequest: Encodable {

    /// Base api to be used in this request
    var baseApi: APIBaseUrl { get }

    /// The type of a response.
    associatedtype Response: APIResponse

    /// Returns a string that describes the contents of the request for presentation in the debugger.
    var debugDescription: String { get }

    /// HTTP method of the request.
    var method: APIRequestMethod { get }

    /// Path of the request. Will be resolved against base URL.
    var path: String { get }

    /// An array of query items for the URL in the order in which they appear in the original query string.
    var queryItems: [URLQueryItem]? { get }

    /// Api version
    var apiVersion: UInt? { get }

    /// If request should be authorized using firebase token
    var authorizationRequired: Bool { get }

    /// Headers to be send in this request, additional to base ones
    var headers: [String: String] { get }

    /// Overrides any token from external providers.
    var customToken: String? { get }

    /// Builds the request against the given `baseURL`.
    ///
    /// - Parameters:
    ///     - baseURL: The base URL to resolve the URL against.
    ///     - additionalHeaders: Additional HTTP headers of the request, to be added to default headers
    ///
    /// - Throws: Any error that occurred during request building.
    ///
    /// - Returns: A built URL request instance.
    func build(additionalHeaders: [String: String]) throws -> URLRequest
}

extension APIRequest {

    public var queryItems: [URLQueryItem]? {
        nil
    }

    public var apiVersion: UInt? {
        switch baseApi {
        case .mainApi: return 1
        case .external: return 1
        case .functions: return nil
        case .custom: return nil
        }
    }

    public var authorizationRequired: Bool {
        true
    }

    var customToken: String? {
        nil
    }

    public var baseApi: APIBaseUrl {
        .mainApi
    }

    public var headers: [String: String] {
        [:]
    }

    /// - SeeAlso: Swift.Encodable
    public func encode(to encoder: Encoder) throws {}

    public var debugDescription: String {
        let body: String = {
            guard let bodyData = try? JSONEncoder().encode(self) else { return "no body" }
            return String(data: bodyData, encoding: .utf8) ?? ""
        }()
        return """
            HTTP method: \(method.rawValue),\n
            Api version: \(String(describing: apiVersion)),\n
            Path: \(fullPath),\n
            Default HTTP headers: \(defaultHeaders) (extra headers excluded),\n
            Additional HTTP headers: \(headers) (extra headers excluded),\n
            Query items: \(String(describing: queryItems)),\n
            JSON body: \(body)\n
        """
    }

    /// - SeeAlso: APIRequest.build(additionalHeaders:)
    public func build(additionalHeaders: [String: String]) throws -> URLRequest {
        guard let url = URL(string: fullPath) else {
            throw APIClientError.requestBuildError
        }
        var request = URLRequest(url: buildURL(againstBaseURL: url))
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60
        request.allHTTPHeaderFields = defaultHeaders
            .appending(elementsOf: headers)
            .appending(elementsOf: additionalHeaders)
        request.httpBody = try? JSONEncoder().encode(self)
        return request
    }
}

private extension APIRequest {

    var fullPath: String {
        basePath + path
    }

    var defaultHeaders: [String: String] {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    func buildURL(againstBaseURL baseURL: URL) -> URL {
        var components = URLComponents()
        components.queryItems = queryItems
        return components.url(relativeTo: baseURL)!
    }

    var basePath: String {
        // TODO: Move to dependency injection
        APIClient.Constants.apiPath
    }
}

public extension Dictionary {

    /// Returns dictionary as JSON.
    var asJson: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }

    /// Appends elements of `other` to `self` and returns the result.
    ///
    /// - Parameter other: The other dictionary.
    /// - Returns: The result of appending `other` to `self`.
    func appending(elementsOf other: [Key: Value]) -> [Key: Value] {
        var memo = self
        for (key, value) in other {
            memo[key] = value
        }
        return memo
    }

    /// Appends elements of `other` to `self`.
    ///
    /// - Parameter other: The other dictionary.
    mutating func append(elementsOf other: [Key: Value]) {
        self = appending(elementsOf: other)
    }
}
