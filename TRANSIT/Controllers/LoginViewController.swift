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

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: Properties
    var user: UserType!
    var returnedMatches: Matches!
    
    // MARK: Methods
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
        
        // Set UITableDelegate for both text fields.
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    // Hide the keyboard when touching oustide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // When return key pressed:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Continue to login field or sign the user in.
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if passwordField.isFirstResponder {
            LogInTapped(UITextField())
        }
        
        return true
    }
    
    // MARK: Actions
    
    // Log the user in [Ray].
    @IBAction func LogInTapped(_ sender: Any) {
        // Perform log in.
        Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
            
            // Give user feedback when authentication failed
            if error != nil {
                UIView.animate(withDuration: 0.05, animations: {
                    
                    let shakeLeft = CGAffineTransform(translationX: -20, y: 0)
                    self.emailField.transform = shakeLeft
                    self.passwordField.transform = shakeLeft
                }) { (_) in
                    UIView.animate(withDuration: 0.05, animations: {
                        let shakeRight = CGAffineTransform(translationX: 20, y: 0)
                        self.emailField.transform = shakeRight
                        self.passwordField.transform = shakeRight
                    }) { (_) in
                        UIView.animate(withDuration: 0.05, animations: {
                            self.emailField.transform = CGAffineTransform.identity
                            self.passwordField.transform = CGAffineTransform.identity
                        })
                    }
                }
            }
        }
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
            
                // Log user in if no error [Ray] else show error message.
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!)
                } else {
                    let registerErrorAlert = UIAlertController(title: "Failed", message: "Failed signing you up, please try again. Make sure your password is 6+ characters.", preferredStyle: .alert)
                    let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
                    registerErrorAlert.addAction(dismiss)
                    self.present(registerErrorAlert, animated: true, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        // Set cancel action.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
        alert.addTextField  {textEmail in
            textEmail.placeholder = "Enter your email"
        }
    
        alert.addTextField {textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter Password (6+ long)"
        }
        
        // Set and show the alert.
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
    
        present(alert, animated: true, completion: nil)
    }
    
    // Unwids to login and empties textfields for security reasons.
    @IBAction func unwindToLogin(unwindSegue: UIStoryboardSegue) {
        do {
            try Auth.auth().signOut()
            emailField.text = ""
            passwordField.text = ""
        } catch {
            print("Error logging out")
        }
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
