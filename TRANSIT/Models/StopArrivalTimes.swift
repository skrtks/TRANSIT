//
//  StopArrivalTimes.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation

// Struct that stores information about arriving trains from TFL API.
struct ArrivingTrain: Decodable {
    var lineName: String
    var towards: String
    var platformName: String
    var timeToStation: Int
}
