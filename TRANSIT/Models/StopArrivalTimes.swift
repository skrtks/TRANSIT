//
//  StopArrivalTimes.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation
import Firebase

struct ArrivingTrain: Decodable {
    var lineName: String
    var towards: String
    var platformName: String
    var timeToStation: Int
}

//struct ArrivingTrains: Decodable {
//    var arrivingTrains: [ArrivingTrain]
//}

