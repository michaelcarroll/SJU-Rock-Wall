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
    
        override func viewDidLoad() {
            super.viewDidLoad()
            let fName = UserDefaults.standard.string(forKey: "fName")
            if (fName != nil) {
                welcomeText.text = ("Welcome " + fName! + ".\n\nThis is the home screen. News will probably be here some day.")
            }
        }
    }
