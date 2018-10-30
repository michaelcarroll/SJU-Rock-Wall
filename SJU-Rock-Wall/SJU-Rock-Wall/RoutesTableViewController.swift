//
//  RoutesTableViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import UIKit

struct JSONResponse: Codable {
    let error: Int
    let message: [Message]
}

struct Message: Codable {
    let rid: Int
    let username, name: String
}

class RoutesTableViewController: UITableViewController {
    var routeNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let json = """
//{
//    "error": 0,
//    "message": [
//        {
//            "rid": 17,
//            "username": "mmm",
//            "name": "test"
//        },
//        {
//            "rid": 12,
//            "username": "1234",
//            "name": "death sentence"
//        }
//    ]
//}
//"""
//        let data = try! JSONDecoder().decode(JSONResponse.self, from: json.data(using: .utf8)!)
//        print(data)
//        var iterator = data.message.makeIterator()
//        while let route = iterator.next() {
//            self.routeNames.append(route.name)
//        }
        
        guard let url = URL(string: "http://sjurockwall.atwebpages.com/getRoutes.php") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                //here dataResponse received from a network request
                let model = try JSONDecoder().decode(JSONResponse.self, from: dataResponse) //Decode JSON Response Data
                print(model)
                
                var iterator = model.message.makeIterator()
                while let route = iterator.next() {
                    self.routeNames.append(route.name)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData() // Add this line and it should work
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
        
//        let jsonUrlString = "http://sjurockwall.atwebpages.com/getRoutes.php"
//        guard let url = URL(string: jsonUrlString) else {return}
//        URLSession.shared.dataTask(with: url) { (data, response, err) in
//            //check error
//            //check response status 200 ok
//            guard let data = data else {return}
//
//            do {
//                let jSONResponse = try? newJSONDecoder().decode(JSONResponse.self, from: jsonData)
//                var iterator = json.message.makeIterator()
//                while let route = iterator.next() {
//                    self.routeNames.append(route.name)
//                }
//            } catch let jsonErr {
//                print("Error serializing json:", jsonErr)
//            }
//        }.resume()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routeNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let currentString = routeNames[indexPath.row]
        cell.textLabel?.text = currentString

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        var descScene = segue.destination as! ViewRouteViewController
        // Pass the selected object to the new view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRoute = routeNames[indexPath.row]
            descScene.test = selectedRoute
        }

    }
}
