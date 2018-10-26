//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email = emailField.text
        let password = passwordField.text
        
        if (email == nil || password == nil) {
            let loginAlert = UIAlertController(title: "Error", message: "Both username and password required.", preferredStyle: UIAlertControllerStyle.alert)
            
            loginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(loginAlert, animated: true, completion: nil)
        }
        
        let json: [String: Any] = ["email": email!, "password": password!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/login.php")!
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
                    let uid = responseJSON["message"] as! Int
                    UserDefaults.standard.set(uid, forKey: "uid")

                    DispatchQueue.main.async {
                        let loginAlert = UIAlertController(title: "Success", message: "Logged in successfully.", preferredStyle: UIAlertControllerStyle.alert)

                       loginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                            self.performSegue(withIdentifier:"LoggedInSegue", sender: nil)
                        }))
                        
                        self.present(loginAlert, animated: true, completion: nil)
                    }
                }
                else if (error == 3) {
                    DispatchQueue.main.async { // use this or it gets mad for not changing UI element on main thread
                        let loginAlert = UIAlertController(title: "Error", message: "Invalid username or password.", preferredStyle: UIAlertControllerStyle.alert)
                        
                        loginAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(loginAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        task.resume()    }
    
}

