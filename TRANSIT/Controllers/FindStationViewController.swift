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

class FindStationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var favStationTable: UITableView!
    
    // MARK: Properties
    var user: UserType!
    let usersRef = Database.database().reference(withPath: "UserList")
    var searchResults: Matches!
    var favStations = [FirebaseStation]()

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the current user for saving stations
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {return}
            self.user = UserType(authData: user)
            
            // Create Firebase path
            let currentUserRef = self.usersRef.child(self.user.userId)
            currentUserRef.setValue(self.user.userId)
            // Set global user so detail view can access user id.
            globalUser = self.user.userId
            self.updateUI()
        }
        
        self.searchField.delegate = self
    }
    
    func updateUI() {
        // Give search button rounded corners
        searchButton.layer.cornerRadius = 5.0
        
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
        
        // Disable search button if search field is empty
        updateSearchButton()
    }
    
    // Update state of search button
    func updateSearchButton() {
        // set color values
        let disabled = #colorLiteral(red: 0.8000000119, green: 0.8000000119, blue: 0.8000000119, alpha: 1)
        let enabled = #colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1)
        // Disable search button if search field is empty
        if searchField.text == "" {
            searchButton.isEnabled = false
            searchButton.backgroundColor = disabled
        } else {
            searchButton.isEnabled = true
            searchButton.backgroundColor = enabled
        }
    }
    
    // Hide the keyboard when touching oustide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // When return key pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performSegue(withIdentifier: "SearchStationSegue", sender: nil)
        return true
    }
    
    // Prepare for segue to results table view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SearchStationSegue" {
            let resultsTableViewController = segue.destination as! ResultsTableViewController
            
            // Pass along the search query.
            resultsTableViewController.searchQuery = searchField.text
        } else if segue.identifier == "fromFavSegue" {
            let indexPath = favStationTable.indexPathForSelectedRow!.row
            let stationDetailViewController = segue.destination as! StationDetailViewController
            
            // Pass along station id and name.
            stationDetailViewController.stationId = self.favStations[indexPath].id
            stationDetailViewController.stationName = self.favStations[indexPath].name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Actions
    // Listen for changes in searchField
    @IBAction func searchFieldEdited() {
        updateSearchButton()
    }
    
    // Animate tapped search button
    @IBAction func searchTapped() {
        UIView.animate(withDuration: 0.1) {
            self.searchButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.searchButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

    // MARK: Table view data source
    // Set the number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    // Set the number of cells.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favStations.count
    }

    // COnfigure the cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseFavCell", for: indexPath)
        cell.textLabel?.text = favStations[indexPath.row].name
        
        return cell
    }
    
    // Deselect cell when returning from detail view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect selected cell
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
