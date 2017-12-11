//
//  StopRequestController.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 06/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//
import Foundation

class RequestController {
    
    static let shared = RequestController()

    func searchForStop(name: String, completion: @escaping (Matches) -> Void) {
        // Set the base URL
        let baseUrl = URL(string: "https://api.tfl.gov.uk/StopPoint/Search/")!

        // Set the required queries
        let query: [String: String] = [
            "maxResults": "20",
            "app_id": "bc6a99cc",
            "app_key": "e9bcc1973c214a342e4b2f969fb5bcdd",
            "modes": "tube",
            "includeHubs": "false"
        ]

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
    
    func requestArrivalData(stopId: String, completion: @escaping ([ArrivingTrain]) -> Void) {
        // Create empty list for temp data storage
        var arrivingTrainsList = [ArrivingTrain]()
        
        // Set the base URL
        let baseUrl = URL(string: "https://api.tfl.gov.uk/StopPoint/")!
        
        // Set the required queries
        let query: [String: String] = [
            "app_id": "bc6a99cc",
            "app_key": "e9bcc1973c214a342e4b2f969fb5bcdd",
        ]
        
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
