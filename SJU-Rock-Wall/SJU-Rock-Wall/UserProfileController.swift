//
//  UserProfileController.swift
//  SJU-Rock-Wall
//
//  Created by Kalsow, Brandan D on 10/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class UserProfileController: UIViewController {
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logoutButtonPress(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "uid")
        self.performSegue(withIdentifier:"LoggedOutSegue", sender: nil)
    }
       
    override func viewDidLoad() {
//        let json: [String: Any] = ["id": UserDefaults.standard.string(forKey: "uid")]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//
//        // create post request
//        let url = URL(string: "http://sjurockwall.atwebpages.com/getUser.php")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        // insert json data to the request
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print(responseJSON)
//
//                let error = responseJSON["error"] as! Int
//                if (error == 0) {
//                    DispatchQueue.main.async {
//                        let createAccountAlert = UIAlertController(title: "Success", message: "Account created successfully.", preferredStyle: UIAlertControllerStyle.alert)
//
//                        createAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
//                            self.performSegue(withIdentifier:"CreatedAccountSegue", sender: nil)
//                        }))
//
//                        self.present(createAccountAlert, animated: true, completion: nil)
//                    }
//                }
//                else if (error == 3) {
//                    DispatchQueue.main.async {
//                        let createAccountAlert = UIAlertController(title: "Error", message: "Account not created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
//
//                        createAccountAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//
//                        self.present(createAccountAlert, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//
//        task.resume()
    }
    }

    


 


