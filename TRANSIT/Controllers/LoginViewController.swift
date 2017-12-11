//
//  LoginViewController.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 04/12/2017.
//  Code under comments marked with [Ray] is from or inspired by https://www.raywenderlich.com/139322/firebase-tutorial-getting-started-2
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    var user: UserType!
    //let usersRef = Database.database().reference(withPath: "Users")
    var returnedMatches: Matches!
    
    // Outlets for textfiels on login screen
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the auth succeeded, then perform segue [Ray].
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
        
        // Set emailField to become first responder.
        emailField.becomeFirstResponder()
    }
    
    // MARK: Actions
    
    // Log the user in [Ray].
    @IBAction func LogInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!)
    }
    
    @IBAction func RegisterTapped(_ sender: Any) {
        // Create alert
        let alert = UIAlertController(title: "Register", message: "Create your account", preferredStyle: .alert)
        
        // Set up the save action [Ray]
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            // Save entries
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            // Create new user in Firebase
            Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            
                // Log user in if no error [Ray]
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!)
                }
            }
        }
        
            // Set cancel action and initiate alert in following lines.
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
            alert.addTextField  {textEmail in
                textEmail.placeholder = "Enter your email"
            }
        
            alert.addTextField {textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Enter Password"
            }
        
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
        
            present(alert, animated: true, completion: nil)
        }
    
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
            emailField.text = ""
            passwordField.text = ""
        } catch {
            print("Error logging out")
        }
    }
    
    // MARK: Methods
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
