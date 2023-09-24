//
//  ComposableArchitectureExampleApp.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct AppView: App {

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MoviesListView(
                    store: Store(initialState: MoviesListReducer.State()) {
                        MoviesListReducer()
                    }
                )
                .navigationDestination(for: MovieOverview.self) { overview in
                    MovieDetailView(
                        store: Store(initialState: MovieDetailReducer.State(movieOverview: overview)) {
                            MovieDetailReducer()
                        }
                    )
                }
            }
        }
    }
}
