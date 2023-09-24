//
//  MovieDetail.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 25/09/2023.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import Dependencies
import Kingfisher

struct MovieDetailReducer: Reducer {
    struct State: Equatable {
        var movieOverview: MovieOverview
        var movieDetail: MovieDetail? = nil
    }

    enum Action: Equatable {
        case viewDidLoad
        case didFetchDetail(MovieDetail)
    }

    @Dependency(\.getMoviesAPIService) var getMoviesService

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .viewDidLoad:
                return .run { [id = state.movieOverview.id] send in
                    let result = try await getMoviesService.getMovieDetail(movieId: "\(id)")
                    await send(.didFetchDetail(result))
                }

            case .didFetchDetail(let detail):
                state.movieDetail = detail
                return .none
            }
        }
    }
}

struct MovieDetailView: View {
    let store: StoreOf<MovieDetailReducer>

    init(store: StoreOf<MovieDetailReducer>) {
        self.store = store
        store.send(.viewDidLoad)
    }
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    KFImage(viewStore.state.movieOverview.largePosterURL)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(viewStore.state.movieOverview.title)
                        .font(.largeTitle)
                    Text(viewStore.state.movieOverview.releaseYear)
                        .font(.footnote)
                    if let detail = viewStore.state.movieDetail {
                        Text(detail.overview)
                            .font(.body)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
        }
    }
}
