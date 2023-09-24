//
//  Models.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation

// MARK: - Movie List
struct MoviesList: Codable {
    let page: Int
    let results: [MovieOverview]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieOverview: Codable, Equatable, Identifiable, Hashable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String?
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    var smallPosterURL: URL? {
        print("\(APIClient.Constants.imagesPath)/w154\(posterPath)")
        return URL(string: "\(APIClient.Constants.imagesPath)/w92\(posterPath)")
    }
    var largePosterURL: URL? {
        URL(string: "\(APIClient.Constants.imagesPath)/w300\(posterPath)")
    }
    var releaseYear: String {
        "\(releaseDate.prefix(4))" // TODO: refactor to use calendar and date formatter
    }

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


// MARK: - Movie Detail
struct MovieDetail: Codable, Equatable {
    let adult: Bool
    let backdropPath: String
    let budget: Int
    let homepage: String
    let id: Int
    let imdbID, originalTitle, overview: String
    let originalLanguage: String?
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let revenue, runtime: Int
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

