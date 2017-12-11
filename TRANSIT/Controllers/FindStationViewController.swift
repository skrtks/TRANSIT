//
//  FindStationViewController.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 04/12/2017.
//  Code under comments marked with [Ray] is from or inspired by https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import UIKit
import Firebase

class FindStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var favStationTable: UITableView!
    
    // MARK: Properties
    var user: UserType!
    let usersRef = Database.database().reference(withPath: "UserList")
    var searchResults: Matches!
    var favStations = [FirebaseStation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {return}
            self.user = UserType(authData: user)
            
            // Make it possible to see who is online [Ray].
            let currentUserRef = self.usersRef.child(self.user.userId)
            currentUserRef.setValue(self.user.userId)
            globalUser = self.user.userId
            self.updateUI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
//    @IBAction func searchTapped(_ sender: Any) {
//        if let searchQuery = searchField.text {
//
//        }
//    }
    
    
    // MARK: Methods
    
    func updateUI() {
        // Load table data for favourite stations
        let ref = Database.database().reference(withPath: "Users/" + self.user.userId + "/favStations")
        ref.observe(.value) { snapshot in
            // Set empty list to capture data
            var newStations = [FirebaseStation]()
            
            // Cycle through found data
            
            for station in snapshot.children {
                let favStation = FirebaseStation(snapshot: station as! DataSnapshot)
                newStations.append(favStation)
            }
            self.favStations = newStations
            self.favStationTable.reloadData()
        }
    }
    
    // Prepare for segue to results table view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchStationSegue" {
            let resultsTableViewController = segue.destination as! ResultsTableViewController
            resultsTableViewController.searchQuery = searchField.text
        } else if segue.identifier == "fromFavSegue" {
            let indexPath = favStationTable.indexPathForSelectedRow!.row
            let stationDetailViewController = segue.destination as! StationDetailViewController
            stationDetailViewController.stationId = self.favStations[indexPath].id
            stationDetailViewController.stationName = self.favStations[indexPath].name
        }
    }


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favStations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseFavCell", for: indexPath)
        cell.textLabel?.text = favStations[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect selected cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
