//
//  ResultsTableViewController.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 04/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import UIKit

class ResultsTableViewController: UITableViewController {

    // MARK: Properties
    var tableSize = 0 // Used to init table on 0 because api data not loaded in time to use name.count for size.
    var searchQuery: String!
    var searchResults: Matches!
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show network indicator.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RequestController.shared.searchForStop(name: searchQuery) { (matches) in
            self.updateUI(with: matches)
        }
        
    }
    
    // Update the UI with fresh data.
    func updateUI(with matches: Matches) {
        // Make sure that refreshing is done in main queue.
        DispatchQueue.main.async {
            self.searchResults = matches
            self.tableSize = self.searchResults.matches.count
            self.tableView.reloadData()
            
            // Hide network indicator.
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    // Prepare for segue to detail view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSegue" {
            let stationDetailViewController = segue.destination as! StationDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!.row
            
            // Pass along station name (clipped from "underground station") and id.
            let stationNameClipped = String(self.searchResults.matches[indexPath].name.dropLast(20))
            stationDetailViewController.stationId = self.searchResults.matches[indexPath].id
            stationDetailViewController.stationName = stationNameClipped
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    // Set number of sections.
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Set number of rows.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableSize
    }

    // Configure the cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseStationCell", for: indexPath)
        cell.textLabel?.text = String(searchResults.matches[indexPath.row].name.dropLast(20))

        return cell
    }
}
