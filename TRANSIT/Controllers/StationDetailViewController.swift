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
    //var tableView: UITableView!
    let ref = Database.database().reference(withPath: "Users/" + globalUser + "/favStations")
    var user: UserType!
    var stationId: String!
    var stationName: String!
    var isSaved = false
    var arrivalData = [ArrivingTrain]()
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RequestController.shared.requestArrivalData(stopId: self.stationId) { (arrivingTrainsData) in
            self.updateUI(with: arrivingTrainsData)
        }
        
        // Check if station is in favourites, update buttons accordingly
        ref.observe(.value, with: { snapshot in
            for item in snapshot.children {
                if FirebaseStation(snapshot: item as! DataSnapshot).id == self.stationId {
                    self.updateBarButtons()
                }
            }
        })
        
        // Initiate Pull to Refresh.
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh…")
        refreshControl.addTarget(self, action: #selector(self.reloadArrivalData), for: UIControlEvents.valueChanged)
        arrivalTableview.addSubview(refreshControl) // not required when using UITableViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    // Update the save and trash buttons.
    func updateBarButtons() {
        if isSaved {
            isSaved = false
            self.saveButton.title = "Save Favourite"
        } else {
            isSaved = true
            self.saveButton.title = "Remove Favourite"
        }
    }
    
    @objc func reloadArrivalData() {
        RequestController.shared.requestArrivalData(stopId: self.stationId) { (arrivingTrainsData) in
            self.updateUI(with: arrivingTrainsData)
        }
    }
    
    // Update the user interface.
    func updateUI(with trains: [ArrivingTrain]) {
        self.arrivalData = trains
        DispatchQueue.main.async {
            self.stationNameLabel.text = self.stationName
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.arrivalTableview.reloadData()
            self.refreshControl.endRefreshing()
            
        }
    }
    
    // MARK: Actions
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return arrivalData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseLineCell", for: indexPath) as! arrivalTimeTableViewCell
//        cell.textLabel?.text = arrivalData[indexPath.row].lineName + " towards " + arrivalData[indexPath.row].towards
        
        // Sort arrival data
        arrivalData.sort {
            $0.timeToStation < $1.timeToStation
        }
//        cell.detailTextLabel?.text = String(arrivalData[indexPath.row].timeToStation/60) + " min"
        cell.update(with: arrivalData[indexPath.row])
        
        return cell
    }
    
//    func updateUI2() {
//
//        DispatchQueue.main.async {
//            self.stationNameLabel.text = self.stationName
//            print("????????????????????")
//            print("????????????????????")
//        }
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}