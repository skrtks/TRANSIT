//
//  FribaseStation.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 09/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation
import Firebase

// Struct for saving favourite station data to firebase.
struct FirebaseStation {
    let key: String
    let ref: DatabaseReference?
    var name: String
    var id: String
    
    init(name: String, id: String, key: String = "") {
        self.key = key
        self.name = name
        self.id = id
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        id = snapshotValue["id"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "id": id,
        ]
    }
}
