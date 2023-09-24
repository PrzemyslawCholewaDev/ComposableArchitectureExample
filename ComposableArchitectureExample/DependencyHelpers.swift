//
//  DependencyHelpers.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation
import Dependencies

extension DependencyValues {
    var getMoviesAPIService: any GetMoviesAPIService {
        get { self[GetMoviesAPIServiceKey.self] }
        set { self[GetMoviesAPIServiceKey.self] = newValue }
    }

    private enum GetMoviesAPIServiceKey: DependencyKey {
        static let liveValue: any GetMoviesAPIService = APIClient.liveValue
    }
}
