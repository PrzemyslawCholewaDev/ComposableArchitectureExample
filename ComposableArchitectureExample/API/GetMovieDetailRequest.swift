//
//  GetMovieDetailRequest.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 25/09/2023.
//

import Foundation

struct GetMovieDetailRequest: APIRequest {

    let movieId: String

    // MARK: APIRequest

    /// - SeeAlso: APIRequest.Response
    typealias Response = GetMovieDetailResponse

    /// - SeeAlso: APIRequestModel.method
    var method: APIRequestMethod {
        .get
    }

    /// - SeeAlso: APIRequestModel.path
    var path: String {
        "/movie/\(movieId)"
    }
}

struct GetMovieDetailResponse: APIResponse {

    // MARK: Properties

    let details: MovieDetail

    // MARK: Initializer

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        details = try container.decode(MovieDetail.self)
    }
}
