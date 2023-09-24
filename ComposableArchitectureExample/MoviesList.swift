//
//  ContentView.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import Kingfisher

struct MoviesListReducer: Reducer {
    struct State: Equatable {
        var movies: IdentifiedArrayOf<MovieOverview> = []
    }

    enum Action: Equatable {
        case viewDidLoad
        case didFetchMovies([MovieOverview])
    }

    @Dependency(\.getMoviesAPIService) var getMoviesService

    var body: some ReducerOf<Self> {
        Reduce<State, Action> { state, action in
            switch action {
            case .viewDidLoad:
                return .run { send in
                    let result = try await getMoviesService.getMovies()
                    await send(.didFetchMovies(result))
                }
                // TODO: Add pagination

            case .didFetchMovies(let movies):
                state.movies.removeAll()
                state.movies.append(contentsOf: movies)
                return .none
            }
        }
    }
}

struct MoviesListView: View {
    let store: StoreOf<MoviesListReducer>

    init(store: StoreOf<MoviesListReducer>) {
        self.store = store
        store.send(.viewDidLoad)
    }
    var body: some View {
        WithViewStore(self.store, observe: \.movies) { viewStore in
            List {
                ForEach(viewStore.state) { movie in
                    NavigationLink(value: movie) {
                        CardView(movie: movie)
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let movie: MovieOverview
    var body: some View {
        HStack {
            KFImage(movie.smallPosterURL)
                .frame(width: 100)
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.releaseYear)
                Spacer()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesListView(
            store: Store(initialState: MoviesListReducer.State()) {
                MoviesListReducer()
            } withDependencies: {
                let configuration = URLSessionConfiguration.ephemeral
                configuration.protocolClasses = [MockURLProtocol.self]
                $0.urlSession = URLSession(configuration: configuration)
                MockURLProtocol.mockJSON = MockURLProtocol.movieListJSON
            }
        )
    }
}
