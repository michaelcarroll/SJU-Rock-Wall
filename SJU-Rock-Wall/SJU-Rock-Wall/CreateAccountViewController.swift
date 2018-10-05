//
//  CreateAccountViewController.swift
//  SJU-Rock-Wall
//
//  Created by Kalsow, Brandan D on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class CreateAccountViewController: UIViewController {
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    @IBAction func buttonPressed(_ sender: Any)
    {
        let fName = fNameField.text
        let lName = lNameField.text
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let confirmPassword = confirmPasswordField.text
        
        if(password != confirmPassword) {
            let passwordMatchAlert = UIAlertController(title: "Error", message: "Passwords don't match. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
            
            passwordMatchAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(passwordMatchAlert, animated: true, completion: nil)
        }
        else {
            let json: [String: Any] = ["fName": fName!, "lName": lName!, "username": username!, "email": email!, "password": password!]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            let url = URL(string: "http://152.65.36.72/createUser.php")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)

                    let error = responseJSON["error"] as! Int
                    if (error == 0) {
                        let createAccountAlert = UIAlertController(title: "Success", message: "Account created successfully.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        createAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                            self.performSegue(withIdentifier:"CreatedAccountSegue", sender: nil)
                        }))
                        
                        self.present(createAccountAlert, animated: true, completion: nil)
                    }
                    else if (error == 3) {
                        let createAccountAlert = UIAlertController(title: "Error", message: "Account not created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        createAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        
                        self.present(createAccountAlert, animated: true, completion: nil)
                    }
                }
            }
            
            task.resume()
        }
    }
}

