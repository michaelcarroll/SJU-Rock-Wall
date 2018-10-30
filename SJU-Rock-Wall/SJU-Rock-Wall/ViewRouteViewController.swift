//
//  CreateAccountViewController.swift
//  SJU-Rock-Wall
//
//  Created by Carroll, Michael G on 10/25/18.
//  Copyright © 2018 Carroll, Michael G. All rights reserved.
//

import Foundation
import UIKit

class ViewRouteViewController: UIViewController {
    @IBOutlet weak var selectedRoute: UITextView!
    var test : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (test != nil){
            selectedRoute.text = test
        }
        
    }
}

