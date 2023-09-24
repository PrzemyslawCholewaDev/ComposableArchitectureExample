//
//  GetMoviesListRequest.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation

struct GetMoviesListRequest: APIRequest {

    // MARK: APIRequest

    /// - SeeAlso: APIRequest.Response
    typealias Response = GetMoviesListResponse

    /// - SeeAlso: APIRequestModel.method
    var method: APIRequestMethod {
        .get
    }

    /// - SeeAlso: APIRequestModel.path
    var path: String {
        "/discover/movie"
    }
}

struct GetMoviesListResponse: APIResponse {

    // MARK: Properties

    let moviesList: MoviesList

    // MARK: Initializer

    /// - SeeAlso: Swift.Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        moviesList = try container.decode(MoviesList.self)
    }
}
