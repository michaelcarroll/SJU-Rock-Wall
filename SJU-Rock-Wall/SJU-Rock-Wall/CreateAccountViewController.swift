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
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var username: UITextField!
    
    
    
    @IBAction func buttonPressed(_ sender: Any)
    {
        if(password.text != confirmPassword.text)
        {
            //alert user that passwords do not match
        }
        }
    
        let json: [String: Any] = ["fName": firstNameField!, "lName": lastNameField, "email": emailField!, "password": password!]
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
    
        
        // create post request
        let url = URL(string: "http://152.65.36.198/login.php")!
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
            }
        }
        
            task.resume()    }
    
}

