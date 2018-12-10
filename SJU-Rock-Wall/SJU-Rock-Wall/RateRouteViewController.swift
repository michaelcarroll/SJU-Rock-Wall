//
//  RateRouteViewController.swift
//  SJU-Rock-Wall
//
//  Created by Michael Carroll on 12/9/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class RateRouteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var routeDifficulty: UITextField!
    
    private var uid: Any?
    var rid : Int?
    var pickerRow: Int = 0
    
    let ratings = ["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10", "V10+"]
    let databaseRatings = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uid = UserDefaults.standard.string(forKey: "uid")
        
        if (uid != nil) {
            // something
        }
        
        let routeRating = UIPickerView()
        routeRating.delegate = self
        routeDifficulty.inputView = routeRating
    }
    
    @IBAction func submitButtonPress(_ sender: Any) {
        print(self.rid!)
        print(self.uid!)
        print(self.pickerRow)
        let json: [String: Any] = ["rid": self.rid!, "uid": self.uid!, "rating": self.pickerRow]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://sjurockwall.atwebpages.com/rate.php")!
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
                        let rateRouteAlert = UIAlertController(title: "Success", message: "Route rated successfully.", preferredStyle: UIAlertController.Style.alert)
                        
                        rateRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(rateRouteAlert, animated: true, completion: nil)
                    }
                }
                else if (error == 3) {
                    DispatchQueue.main.async {
                        let rateRouteAlert = UIAlertController(title: "Error", message: "Route not rated. Please try again.", preferredStyle: UIAlertController.Style.alert)
                        
                        rateRouteAlert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        
                        self.present(rateRouteAlert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        routeDifficulty.text = ratings[row]
        self.pickerRow = row
    }
}
