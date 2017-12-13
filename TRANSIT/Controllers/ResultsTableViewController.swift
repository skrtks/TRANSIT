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
    var tableSize = 0
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
