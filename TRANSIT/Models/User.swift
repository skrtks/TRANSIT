//
//  User.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 05/12/2017.
//  Code under comments marked with [Ray] is from or inspired by https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import Foundation
import Firebase

// Create the UserType struct [Ray].
struct UserType {
    let userId: String
    let email: String
    
    init(authData: User) {
        userId = authData.uid
        email = authData.email!
    }
    
    init(userId: String, email: String) {
        self.userId = userId
        self.email = email
    }
}

var globalUser: String!
