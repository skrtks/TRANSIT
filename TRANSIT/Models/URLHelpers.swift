//
//  URLHelpers.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation

// Extension that appends query items to URL
extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap
            { URLQueryItem(name: $0.0, value: $0.1) }
        return components?.url
    }
}
