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
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        let username = UserDefaults.standard.string(forKey: "username")
        let email = UserDefaults.standard.string(forKey: "email")
        let fName = UserDefaults.standard.string(forKey: "fName")
        let lName = UserDefaults.standard.string(forKey: "lName")
        
        navigationBar.title = "Profile"
        self.username.text = username
        self.email.text = email
        self.name.text = fName! + " " + lName!
        
    }

    @IBAction func logoutButtonPress(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "uid")
        UserDefaults.standard.set(nil, forKey: "email")
        UserDefaults.standard.set(nil, forKey: "username")
        UserDefaults.standard.set(nil, forKey: "lName")
        UserDefaults.standard.set(nil, forKey: "fName")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "GuestTabBarController")
        self.present(viewController, animated: true, completion: nil)
    }
}

    


 


