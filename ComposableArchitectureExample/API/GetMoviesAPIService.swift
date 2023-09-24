//
//  GetMoviesAPIService.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation
import Dependencies

protocol GetMoviesAPIService: DependencyKey {
    func getMovies() async throws -> [MovieOverview]
    func getMovieDetail(movieId: String) async throws -> MovieDetail
}

extension APIClient: GetMoviesAPIService {

    func getMovies() async throws -> [MovieOverview] {
        let request = GetMoviesListRequest()
        let response = try await perform(request: request)
        return response.moviesList.results
    }

    func getMovieDetail(movieId: String) async throws -> MovieDetail {
        let request = GetMovieDetailRequest(movieId: movieId)
        let response = try await perform(request: request)
        return response.details
    }
}
