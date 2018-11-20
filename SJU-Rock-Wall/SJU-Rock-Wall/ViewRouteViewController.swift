//
//  CreateAccountViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Carroll, Michael G. All rights reserved.
//
import Foundation
import UIKit
import SceneKit

struct JSONResponse: Codable {
    let error: Int
    let message: Message
}

struct Message: Codable {
    let rid: Int
    let uid: Int
    let username: String
    let name: String
    let description: String
    let wallState: String?
    let creationDate: String
    let rating: Double
    let cRating: String
}

class ViewRouteViewController: UIViewController {
    var selectedRoute : Int?
    
    @IBOutlet weak var routeName: UITextView!
    @IBOutlet weak var routeUsername: UITextView!
    @IBOutlet weak var routeCreationDate: UITextView!
    @IBOutlet weak var routeRating: UITextView!
    @IBOutlet weak var routeDescription: UITextView!
    @IBOutlet weak var routeScene: SCNView!
    
    var scene: SCNScene!
    var serialScene: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scene = SCNScene(named: "rockWall-2.scn")
        
        let json: [String: Any] = ["id": selectedRoute!]
        print(selectedRoute)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/getRoute.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            print("JSON String: \(String(data: dataResponse, encoding: .utf8))")
            do {
                //here dataResponse received from a network request
                let model = try JSONDecoder().decode(JSONResponse.self, from: dataResponse) //Decode JSON Response Data
                print(model)
                
                self.serialScene = model.message.wallState
                let serializer = SceneSerializer.init(scene: self.scene)
                self.scene = serializer.unserializeScene(serialScene: self.serialScene)
                
                //self.routeScene = self.view as? SCNView
                //scnView.showsStatistics = true
                //scnView.allowsCameraControl = true
                //scnView.autoenablesDefaultLighting = true
                
                
                DispatchQueue.main.async {
                    self.routeName.text = model.message.name
                    self.routeUsername.text = "@\(model.message.username)"
                    self.routeCreationDate.text = "Created: \(model.message.creationDate)"
                    self.routeRating.text = "Rating: \(model.message.rating)"
                    self.routeDescription.text = "Description: \(model.message.description)"
                    //self.routeScene.scene = self.scene
                }
                
                
                
            }
            catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
