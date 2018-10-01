//
//  GameViewController.swift
//  SJU-Rock-Wall
//
//  Created by Tran, Anh B on 9/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var sphere1: SCNNode!
    var sphere2: SCNNode!
    var sphere3: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        spawnShape()
        // retrieve the sphere1 node
        sphere1 = scnScene.rootNode.childNode(withName: "sphere1", recursively: true)!
        // retrieve the shpere2 node
        sphere2 = scnScene.rootNode.childNode(withName: "sphere2", recursively: true)!
        // retrieve the shpere3 node
        sphere3 = scnScene.rootNode.childNode(withName: "sphere3", recursively: true)!
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognie: UIGestureRecognizer){
        let p = gestureRecognie.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        
        if hitResults.count>0 {
            let result = hitResults[0]
            if(result.node == sphere1){
                sphere1.geometry!.firstMaterial!.emission.contents = UIColor.red
            }
            else if(result.node == sphere2){
                // Un-share the geometry by copying
                sphere2.geometry = sphere1.geometry!.copy() as? SCNGeometry
                // Un-share the material, too
                sphere2.geometry?.firstMaterial = sphere1.geometry?.firstMaterial!.copy() as? SCNMaterial
                // Now, we can change node's material without changing parent and other childs:
                sphere2.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
            else if(result.node == sphere3){
                sphere3.geometry = sphere1.geometry!.copy() as? SCNGeometry
                // Un-share the material, too
                sphere3.geometry?.firstMaterial = sphere1.geometry?.firstMaterial!.copy() as? SCNMaterial
                // Now, we can change node's material without changing parent and other childs:
                sphere3.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
            else{
                //do nothing
            }

        }
    }
    
    func shouldAutorotate() -> Bool {
        return true
    }
    
    func prefersStatusBarHidden() -> Bool {
        return true
    }
    func setupView() {
        scnView = self.view as! SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
    }
    func setupScene() {
        scnScene = SCNScene(named: "rockWall.scn")
        scnView.scene = scnScene
        scnView.backgroundColor = UIColor.white
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        cameraNode.camera = SCNCamera()
        // 3
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        // 4
        //scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        // 1
        /*var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        case .Box:
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 1.0)
        case .Sphere:
            geometry = SCNSphere(radius: 0.5)
        case .Pyramid:
            geometry = SCNPyramid(width: 1.0, height: 1.0, length: 1.0)
        default:
            // 3
            geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.0)
        }
         //
        let geometryNode = SCNNode(geometry: geometry)
        // 5
        scnScene.rootNode.addChildNode(geometryNode)*/
    }
}
