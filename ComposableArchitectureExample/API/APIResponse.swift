//
//  APIResponse.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 23/09/2023.
//

import Foundation

public protocol APIResponse: Decodable {

    /// A decoder to be used when decoding a response.
    static var decoder: JSONDecoder { get }
}

extension APIResponse {

    public static var decoder: JSONDecoder {
        JSONDecoder()
    }
}

extension String: APIResponse {}

struct NoDataResponse: APIResponse {}
