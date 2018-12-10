//
//  ViewRouteSceneController.swift
//  SJU-Rock-Wall
//
//  Created by Michael Carroll on 12/9/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

class ViewRouteSceneController: UIViewController {
    var scnView: SCNView!
    var scene: SCNScene!
    var serialScene: String!
    var cameraNode: SCNNode!
    
    @IBOutlet weak var routeScene: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scene = SCNScene(named: "rockWall-2.scn")
        let serializer = SceneSerializer.init(scene: self.scene)
        self.scene = serializer.unserializeScene(serialScene: self.serialScene)
        
        self.routeScene.scene = self.scene
}
}

