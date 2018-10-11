//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class CreateRouteViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var routeName: UITextField!
    @IBOutlet weak var routeDifficulty: UITextField!
    @IBOutlet weak var routeDescription: UITextField!
    
    private var username: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = UserDefaults.standard.string(forKey: "username")
        if (username != nil) {
            // something
        }
    }
    
    @IBAction func doneButtonPress(_ sender: Any) {
        let name = routeName.text
        let difficulty = routeDifficulty.text
        let description = routeDescription.text
        
        let json: [String: Any] = ["username": username!, "name": name!, "difficulty" : difficulty!, "description": description!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://152.65.37.180/createRoute.php")!
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
        
        task.resume()
    }
    
}
