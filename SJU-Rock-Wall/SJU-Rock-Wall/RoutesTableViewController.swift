//
//  RoutesTableViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController {
    struct JSONResponse: Codable {
        let error: Int
        let message: [Message]
    }
    
    struct Message: Codable {
        let rid: Int
        let username, name: String
    }
    
    var routeNames = [String]()
    var routeArrayOfDictionary = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.downloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.downloadData()
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        self.downloadData()
        sender.endRefreshing()
    }
    
    func downloadData() {
        // reset arrays to empty
        routeNames = [String]()
        routeArrayOfDictionary = [Message]()
        
        guard let url = URL(string: "http://sjurockwall.atwebpages.com/getRoutes.php") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                
                self.routeArrayOfDictionary = model.message
                
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
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
        guard segue.identifier == "cellSelected" else {return}
        var descScene = segue.destination as! ViewRouteViewController
        // Pass the selected object to the new view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let selectedRoute = routeNames[indexPath.row]
            
            var iterator = routeArrayOfDictionary.makeIterator()
            while let route = iterator.next() {
                if (route.name == selectedRoute) {
                    descScene.selectedRoute = route.rid
                }
            }

        }

    }
}
