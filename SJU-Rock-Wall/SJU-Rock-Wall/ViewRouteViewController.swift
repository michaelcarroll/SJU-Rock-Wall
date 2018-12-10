//
//  CreateAccountViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Carroll, Michael G. All rights reserved.
//
import Foundation
import UIKit

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
    @IBOutlet weak var cRating: UITextView!
    @IBOutlet weak var routeDescription: UITextView!
    
    let ratings = ["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V10+"]
    var serialScene = "{"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //give scene an intial value
        
        let json: [String: Any] = ["id": selectedRoute!]
        //print(selectedRoute)
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
            //print("JSON String: \(String(data: dataResponse, encoding: .utf8))")
            do {
                //here dataResponse received from a network request
                let model = try JSONDecoder().decode(JSONResponse.self, from: dataResponse) //Decode JSON Response Data
                print(model)
                
                self.serialScene = model.message.wallState!
                
                DispatchQueue.main.async {
                    self.routeName.text = model.message.name
                    self.routeUsername.text = "@\(model.message.username)"
                    self.routeCreationDate.text = "Created: \(model.message.creationDate)"
                    self.routeRating.text = "Rating: \(self.ratings[Int(model.message.rating)])"
                    
                    var cRatingDouble = Double(model.message.cRating)!
                    
                    var cRatingText = "V1-2"
                    if (cRatingDouble > 0.0 && cRatingDouble < 1.0){
                        cRatingText = "V1-2"
                    }
                    else if (cRatingDouble > 1.0 && cRatingDouble < 2.0){
                        cRatingText = "V2-3"
                    }
                    else if (cRatingDouble > 2.0 && cRatingDouble < 3.0){
                        cRatingText = "V3-4"
                    }
                    else if (cRatingDouble > 3.0 && cRatingDouble < 4.0){
                        cRatingText = "V4-5"
                    }
                    else if (cRatingDouble > 4.0 && cRatingDouble < 5.0){
                        cRatingText = "V5-6"
                    }
                    else if (cRatingDouble > 5.0 && cRatingDouble < 6.0){
                        cRatingText = "V6-7"
                    }
                    else if (cRatingDouble > 6.0 && cRatingDouble < 7.0){
                        cRatingText = "V7-8"
                    }
                    else if (cRatingDouble > 7.0 && cRatingDouble < 8.0){
                        cRatingText = "V8-9"
                    }
                    else if (cRatingDouble > 8.0 && cRatingDouble < 9.0){
                        cRatingText = "V9-10"
                    }
                    else if (cRatingDouble > 9.0 && cRatingDouble < 10.0){
                        cRatingText = "V10-10+"
                    }
                    else {
                        cRatingText = String(self.ratings[Int(cRatingDouble)])
                    }
                    
                    self.cRating.text = "Community Rating: " + cRatingText
                    self.routeDescription.text = "Description: \(model.message.description)"
                }
                
            }
            catch let parsingError {
                print("Error", parsingError)
                print("Raw JSON String: \(String(describing: String(data: dataResponse, encoding: .utf8)))")
            }
        }
        task.resume()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        guard segue.identifier == "viewScene" else {return}
        var descScene = segue.destination as! ViewRouteSceneController
        // Pass the selected object to the new view controller.
         descScene.serialScene = self.serialScene
    }
}
