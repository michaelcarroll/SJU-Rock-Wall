//
//  LoginViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/1/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var welcomeText: UITextView!
    @IBOutlet weak var userButton: UIBarButtonItem!
    @IBOutlet var newRouteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        let username = UserDefaults.standard.string(forKey: "username")
        if (username != nil) {
            welcomeText.text = username!
            userButton.title = "Profile"
            self.navigationItem.rightBarButtonItem = newRouteButton
        }
    }
}

