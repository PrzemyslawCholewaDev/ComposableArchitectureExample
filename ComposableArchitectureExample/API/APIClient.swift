//
//  APIClient.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation
import Dependencies

/// Client without external authentication support. It tries to take token directly from the request.
class APIClient: DependencyKey {
    enum Constants {
        static let apiPath = "https://api.themoviedb.org/3"
        static let imagesPath = "https://image.tmdb.org/t/p"
    }
    static let liveValue = APIClient()

    @Dependency(\.urlSession) private var urlSession

    /// Default HTTP request headers.
    var defaultRequestHeaders: [String: String] {
        [
            "Accept": "application/json",
            "Accept-Language": Locale.preferredLanguages.first ?? "de"
        ]
    }

    /// A range of acceptable status codes.
    private let defaultAcceptableStatusCodes = 200...299

    /// Performs the API request and calls completion block with its response.
    /// Fetches token from firebase if authorization is needed
    ///
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - completion: The completion closure containing result of an operation.
    func perform<Request>(request: Request) async throws -> Request.Response where Request: APIRequest {

        // Build a headers.
        var additionalHeaders = [String: String]()
        if request.authorizationRequired {
            // TODO: ⚠️ Move auth key to dependency injection, and use tool like Cocoa Keys to not store this in repository
            let authToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3MWQ0NGQ1MTE1ZGJhYTM0ZGU2MjI3ODRiNzM1YjlhNCIsInN1YiI6IjY1MGViNzIyZThkMGI0MDEwY2UyZWE2NSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.7j8hwtLnq8L45Cay3DApizQVZPgKJEnEEIXcFggGXqY"
            additionalHeaders["Authorization"] = authToken
        }

        do {
            // Build a request.
            for key in defaultRequestHeaders.keys {
                additionalHeaders[key] = defaultRequestHeaders[key]
            }
            let request = try request.build(
                additionalHeaders: additionalHeaders
            )

            print("-------- Sending Request ----------")
            print(request.curl())

            // Send a built request.
            let (data, response) = try await urlSession.data(for: request)

            // If the response is invalid, resolve failure immediately.
            guard let response = response as? HTTPURLResponse else {
                throw APIClientError.responseValidationError
            }

            // Validate against acceptable status codes.
            guard self.defaultAcceptableStatusCodes.contains(response.statusCode) else {
                throw APIClientError.wrongStatusCode(response.statusCode)
            }

            // If request needs no response data, return success
            if let noDataResponse = NoDataResponse() as? Request.Response {
                return noDataResponse
            }

            print("-------- Received data ------- \(String(data: data, encoding: .utf8) ?? "N/A")")

            // Additional support for String type.
            if
                let _ = String() as? Request.Response,
                let result = String(data: data, encoding: .utf8)
            {
                return result as! Request.Response
            }

            do {
                // Parse a response.

                let decoder = Request.Response.decoder
                let parsedResponse = try decoder.decode(Request.Response.self, from: data)

                // Resolve success with a parsed response.
                return parsedResponse

            } catch {
                throw APIClientError.responseParseError(error)
            }
        } catch {
            throw APIError(statusCode: nil, underlyingError: error, responseError: nil)
        }
    }
}
