//
//  URLRequest+curlPrinting.swift
//  ComposableArchitectureExample
//
//  Created by Przemyslaw Cholewa on 24/09/2023.
//

import Foundation

extension URLRequest {

    public func curl(pretty: Bool = false) -> String {

        var data: String = ""
        let complement = pretty ? "\\\n" : ""
        let method = "-X \(httpMethod ?? "GET") \(complement)"
        let url = "\"" + (self.url?.absoluteString ?? "") + "\""

        var header = ""

        if let httpHeaders = allHTTPHeaderFields?.sorted(by: { element1, element2 -> Bool in
            element1.key > element2.key
        }) {
            for (key, value) in httpHeaders {
                header += "-H \"\(key): \(value)\" \(complement)"
            }
        }

        if let bodyData = httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            data = "-d \'\(bodyString)\' \(complement)"
        }

        let command = "curl -i " + complement + method + header + data + url

        return command
    }
}
