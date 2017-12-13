//
//  StopRequestController.swift
//  TRANSIT
//
//  Code under comments marked with [Ray] is from or inspired by https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//
import Foundation

class RequestController {
    
    // Shared static is used to share the requestController among viewcontrollers [Ray].
    static let shared = RequestController()

    // Searches for stop by its common name using the TFL API.
    func searchForStop(name: String, completion: @escaping (Matches) -> Void) {
        // Set the base URL
        let baseUrl = URL(string: "https://api.tfl.gov.uk/StopPoint/Search/")!

        // Set queries
        let query: [String: String] = [
            "maxResults": "20",
            "app_id": "bc6a99cc",
            "app_key": "e9bcc1973c214a342e4b2f969fb5bcdd",
            "modes": "tube",
            "includeHubs": "false"
        ]

        // Set the search query to the provided string.
        let searchPathComponent = name

        // Append queries to URL.
        var url = baseUrl.withQueries(query)!

        // Append search part of path to URL.
        url.appendPathComponent(searchPathComponent)

        // Set up the network task.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let returnedMatches = try? jsonDecoder.decode(Matches.self, from: data) {
                completion(returnedMatches)
            }
        }
        task.resume()
    }
    
    // Requests arrival data for station using TFL station id from TFL API.
    func requestArrivalData(stopId: String, completion: @escaping ([ArrivingTrain]) -> Void) {
        // Create empty list for temp data storage.
        var arrivingTrainsList = [ArrivingTrain]()
        
        // Set the base URL.
        let baseUrl = URL(string: "https://api.tfl.gov.uk/StopPoint/")!
        
        // Set queries
        let query: [String: String] = [
            "app_id": "bc6a99cc",
            "app_key": "e9bcc1973c214a342e4b2f969fb5bcdd",
        ]
        
        // Set the search query to the provided string.
        let searchPathComponent = stopId + "/Arrivals"
        
        // Append queries to URL.
        var url = baseUrl.withQueries(query)!
        
        // Append search part of path to URL.
        url.appendPathComponent(searchPathComponent)
        
        // Set up the network task.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data)
                    for train in jsonResult as! [Dictionary<String, Any>] {
                        let lineName = train["lineName"] as! String
                        let towards = train["towards"] as! String
                        let platformName = train["platformName"] as! String
                        let timeToStation = train["timeToStation"] as! Int
                        let arrivingTrain = ArrivingTrain(lineName: lineName, towards: towards, platformName: platformName, timeToStation: timeToStation)
                        arrivingTrainsList.append(arrivingTrain)
                        completion(arrivingTrainsList)
                    }
                } catch {
                    print("error")
                }
            }
        }
        task.resume()
    }
}
