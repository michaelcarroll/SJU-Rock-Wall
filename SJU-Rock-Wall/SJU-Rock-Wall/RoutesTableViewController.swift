//
//  RoutesTableViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import UIKit

class RoutesTableViewController: UITableViewController, UISearchBarDelegate {
    struct JSONResponse: Codable {
        let error: Int
        let message: [Message]
    }
    
    struct Message: Codable {
        let rid: Int
        let rating: Int
        let username, name: String
    }
    
    var routeNames = [String]()
    var routeAuthors = [String]()
    var routeRating = [Int]()
    var routeArrayOfDictionary = [Message]()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    var ratingPreference = "All"
    
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredData: [String]!
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(self.downloadData), for: UIControl.Event.valueChanged)
        self.refreshControl = refreshControl
        searchBar.delegate = self
        
        self.downloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        self.filteredData = self.routeNames
        filteredData = filteredData.filter({$0.prefix(searchText.count).lowercased() == searchText.lowercased()})
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.downloadData()
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searching = false
        self.downloadData()
        DispatchQueue.main.async {
            self.tableView.reloadData();
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.downloadData() commented out because index sometimes goes out of range if you switch tabs quickly...
    }
    
    @objc func downloadData() {
        self.searching = false
        // reset arrays to empty
        
        routeNames = [String]()
        routeAuthors = [String]()
        routeRating = [Int]()
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
                    if (self.ratingPreference == "All") {
                        self.routeNames.append(route.name)
                        self.routeAuthors.append(route.username)
                        self.routeRating.append(route.rating)
                    }
                    if (self.ratingPreference == "Beginner") {
                        if (route.rating <= 3) {
                            self.routeNames.append(route.name)
                            self.routeAuthors.append(route.username)
                            self.routeRating.append(route.rating)
                        }
                    }
                    if (self.ratingPreference == "Intermediate") {
                        if (route.rating > 3 && route.rating < 7) {
                            self.routeNames.append(route.name)
                            self.routeAuthors.append(route.username)
                            self.routeRating.append(route.rating)
                        }
                    }
                    if (self.ratingPreference == "Expert") {
                        if (route.rating > 7) {
                            self.routeNames.append(route.name)
                            self.routeAuthors.append(route.username)
                            self.routeRating.append(route.rating)
                        }
                    }
                }
                
                self.routeArrayOfDictionary = model.message
                
                DispatchQueue.main.async {
                    self.tableView.reloadData();
                    self.refreshControl?.endRefreshing()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
                print("Raw JSON String: \(String(describing: String(data: dataResponse, encoding: .utf8)))")
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
        if searching {
            return filteredData.count
        }
        else {
        return routeNames.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as UITableViewCell
        
        if searching {
            let currentRoute = filteredData[indexPath.row]
            cell.textLabel?.text = currentRoute
            cell.detailTextLabel?.text = "" // not sure how to add author to search result cell, index is off in filted array
            return cell
        }
        
        let currentRoute = routeNames[indexPath.row]
        let currentAuthor = routeAuthors[indexPath.row]
        let currentRating = routeRating[indexPath.row]
        
        cell.textLabel?.text = currentRoute
        cell.detailTextLabel?.text = currentAuthor

        return cell
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController.init(title: "Filter routes", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction.init(title: "All", style: UIAlertAction.Style.default, handler: { (action) in
            self.filter(rating: "All")
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Beginner", style: UIAlertAction.Style.default, handler: { (action) in
            self.filter(rating: "Beginner")
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Intermediate", style: UIAlertAction.Style.default, handler: { (action) in
            self.filter(rating: "Intermediate")
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Expert", style: UIAlertAction.Style.default, handler: { (action) in
            self.filter(rating: "Expert")
        }))
        actionSheet.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) in
            // self.dismissViewControllerAnimated(true, completion: nil) is not needed, this is handled automatically,
            //Plus whatever method you define here, gets called,
            //If you tap outside the UIAlertController action buttons area, then also this handler gets called.
        }))
        //Present the controller
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func filter(rating: String){
        if rating == "Beginner" {
            self.ratingPreference = "Beginner"
            self.downloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
        
        if rating == "Intermediate" {
            self.ratingPreference = "Intermediate"
            self.downloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
        
        if rating == "Expert" {
            self.ratingPreference = "Expert"
            self.downloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
        
        if rating == "All" {
            self.ratingPreference = "All"
            self.downloadData()
            DispatchQueue.main.async {
                self.tableView.reloadData();
            }
        }
    }
    //searching https://github.com/codepath/ios_guides/wiki/Search-Bar-Guide
    

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
