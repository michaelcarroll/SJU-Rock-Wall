//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class MemberHomeViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var welcomeText: UITextView!
    
    @IBAction func logoutButtonPress(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: "username")
        self.performSegue(withIdentifier:"LoggedOutSegue", sender: nil)
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            let username = UserDefaults.standard.string(forKey: "username")
            if (username != nil) {
                welcomeText.text = ("Welcome " + username! + "\n\n This is the home screen. News will probably be here some day.")
            }
        }
    }
