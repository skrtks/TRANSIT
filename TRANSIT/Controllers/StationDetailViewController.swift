//
//  StationDetailViewController.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 04/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import UIKit
import Firebase

class StationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var arrivalTableview: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Properties
    let ref = Database.database().reference(withPath: "Users/" + globalUser + "/favStations")
    var user: UserType!
    var stationId: String!
    var stationName: String!
    var isSaved = false
    var arrivalData = [ArrivingTrain]()
    var refreshControl: UIRefreshControl!

    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make network indicator visible.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        // Request arrival data.
        RequestController.shared.requestArrivalData(stopId: self.stationId) { (arrivingTrainsData) in
            self.updateUI(with: arrivingTrainsData)
        }
        
        // Check if station is in favourites, update button accordingly
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if FirebaseStation(snapshot: item as! DataSnapshot).id == self.stationId {
                    self.updateBarButtons()
                }
            }
        })
        
        // Initiate Pull to Refresh (inspired on jandro_es on https://stackoverflow.com/questions/38184255/refresh-control-on-top-of-tableview-when-i-go-back-to-view-controller.)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh…")
        refreshControl.addTarget(self, action: #selector(self.reloadArrivalData), for: UIControlEvents.valueChanged)
        // Prevent refresh control showing over table.
        arrivalTableview.backgroundView = refreshControl
        
    }
    
    // Update the user interface.
    func updateUI(with trains: [ArrivingTrain]) {
        self.arrivalData = trains
        DispatchQueue.main.async {
            self.stationNameLabel.text = self.stationName
            
            // Hide network indicator.
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            // Reload table.
            self.arrivalTableview.reloadData()
            
            // Hide refreshing control.
            self.refreshControl.endRefreshing()
            
        }
    }
    
    // Update the star button.
    func updateBarButtons() {
        if isSaved {
            isSaved = false
            self.saveButton.image = UIImage(named: "Star")
        } else {
            isSaved = true
            self.saveButton.image = UIImage(named: "Star_filled")
        }
    }
    
    // Reload arrival data upon request.
    @objc func reloadArrivalData() {
        RequestController.shared.requestArrivalData(stopId: self.stationId) { (arrivingTrainsData) in
            self.updateUI(with: arrivingTrainsData)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    
    // Save or remove the favourite sation from Firebase.
    @IBAction func saveButtonTapped(_ sender: Any) {
        if self.isSaved {
            let stationToRemove = self.ref.child(stationName)
            stationToRemove.ref.removeValue()
            self.updateBarButtons()
        } else {
            guard let stationName = stationName, let stationId = stationId else {return}
            let favStation = FirebaseStation(name: stationName, id: stationId)
            
            let favStationRef = self.ref.child(stationName)
            
            favStationRef.setValue(favStation.toAnyObject())
        }
    }
 
    
    // MARK: - Table view data source
    // Set number of sections.
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    // Set number of rows.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrivalData.count
    }
    
    // Configure cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseLineCell", for: indexPath) as! arrivalTimeTableViewCell
        
        // Sort arrival data
        arrivalData.sort {
            $0.timeToStation < $1.timeToStation
        }

        cell.update(with: arrivalData[indexPath.row])
        
        return cell
    }
}
