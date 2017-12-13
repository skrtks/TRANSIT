//
//  StationInfo.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation

// Structs to store station details from TFL API.
struct Match: Decodable {
    var id: String
    var name: String
    var lat: Double
    var lon: Double
}

struct Matches: Decodable {
    var matches: [Match]
}

