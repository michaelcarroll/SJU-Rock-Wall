//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class CreateRouteViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIBarButtonItem!
    @IBOutlet weak var routeName: UITextField!
    @IBOutlet weak var routeDifficulty: UITextField!
    @IBOutlet weak var routeDescription: UITextField!
    private var sceneFile: SCNScene!
    private var serialScene: String!
    
    private var username: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username = UserDefaults.standard.string(forKey: "username")
        
        sceneFile = SCNScene(named: "SerialTest.scn")
        
        print(sceneFile)
        
        let serializer = SceneSerializer.init(scene: sceneFile)
        serialScene = serializer.serializeScene()
        print(serialScene)
        
        let unserialized = serializer.unserializeScene(serialScene: serialScene)
        print(unserialized)
        
        if (username != nil) {
            // something
        }
    }
    
    @IBAction func submitButtonPress(_ sender: Any) {
        let name = routeName.text
        let difficulty = routeDifficulty.text
        let description = routeDescription.text

        let json: [String: Any] = ["username": username!, "name": name!, "difficulty" : difficulty!, "description": description!]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/createUser.php")!
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
                    DispatchQueue.main.async {
                        let createRouteAlert = UIAlertController(title: "Success", message: "Route created successfully.", preferredStyle: UIAlertControllerStyle.alert)
                    
                        createRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                        self.present(createRouteAlert, animated: true, completion: nil)
                    }
                }
                else if (error == 3) {
                    DispatchQueue.main.async {
                        let createRouteAlert = UIAlertController(title: "Error", message: "Route not created. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                        createRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                        self.present(createRouteAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        task.resume()
    }
    
}
