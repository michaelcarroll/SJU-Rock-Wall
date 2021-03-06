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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var serialScene: String!
    
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraOrbit: SCNNode!
    var cameraNode: SCNNode!
    var wall: SCNNode!
    var wedge: SCNNode!
    var text: SCNNode!
    var camera: SCNCamera!
    //HANDLE PAN CAMERA
    var lastWidthRatio: Float = 0
    var lastHeightRatio: Float = 0.2
    var WidthRatio: Float = 0
    var HeightRatio: Float = 0.2
    var fingersNeededToPan = 1
    var maxWidthRatioRight: Float = 0.2
    var maxWidthRatioLeft: Float = -0.2
    var maxHeightRatioXDown: Float = 0.02
    var maxHeightRatioXUp: Float = 0.4

    //HANDLE PINCH CAMERA
    var pinchAttenuation = 20.0  //1.0: very fast ---- 100.0 very slow
    var lastFingersNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        //setupCamera()
        // retrieve the wall node
        wall = scnScene.rootNode.childNode(withName: "wall", recursively: true)!
        // retrieve the wedge node
        wedge = scnScene.rootNode.childNode(withName: "wedge", recursively: true)!

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add a tap gesture recognizer
        //let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        //scnView.addGestureRecognizer(panGesture)
        
        // add a pinch gesture recognizer
        //let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        //pinchRecognizer.delegate = self as? UIGestureRecognizerDelegate
        //scnView.addGestureRecognizer(pinchRecognizer)
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        let serializer = SceneSerializer.init(scene: scnScene)
        serialScene = serializer.serializeScene()
        
        self.performSegue(withIdentifier:"saveScene", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var descScene = segue.destination as! CreateRouteViewController
        descScene.serialScene = serialScene
    }
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer)
    {
        let p = gestureRecognize.location(in: scnView)
        let result = nodeNearPoint(container: scnScene, point: p)
        if((result.geometry!.firstMaterial?.emission.contents! as AnyObject).isEqual(UIColor.red))
        {
            result.geometry!.firstMaterial!.emission.contents = UIColor.yellow
        }
        else if((result.geometry!.firstMaterial?.emission.contents! as AnyObject).isEqual(UIColor.yellow))
        {
            result.geometry!.firstMaterial!.emission.contents = UIColor.orange
        }
        else if((result.geometry!.firstMaterial?.emission.contents! as AnyObject).isEqual(UIColor.orange))
        {
            result.geometry!.firstMaterial!.emission.contents = UIColor.black
        }
        else
        {
            result.geometry!.firstMaterial!.emission.contents = UIColor.red
        }
    }
    
    @objc func handlePan(_ gestureRecognize: UIPanGestureRecognizer) {
        
        let numberOfTouches = gestureRecognize.numberOfTouches
        
        let translation = gestureRecognize.translation(in: gestureRecognize.view!)
        
        if (numberOfTouches==fingersNeededToPan) {
            
            WidthRatio = Float(translation.x) / Float(gestureRecognize.view!.frame.size.width) + lastWidthRatio
            HeightRatio = Float(translation.y) / Float(gestureRecognize.view!.frame.size.height) + lastHeightRatio
            
            //  HEIGHT constraints
            if (HeightRatio >= maxHeightRatioXUp ) {
                HeightRatio = maxHeightRatioXUp
            }
            if (HeightRatio <= maxHeightRatioXDown ) {
                HeightRatio = maxHeightRatioXDown
            }
            
            
            //  WIDTH constraints
            if(WidthRatio >= maxWidthRatioRight) {
                WidthRatio = maxWidthRatioRight
            }
            if(WidthRatio <= maxWidthRatioLeft) {
                WidthRatio = maxWidthRatioLeft
            }
            
            self.cameraOrbit.eulerAngles.y = Float(-2 * Double.pi) * WidthRatio
            self.cameraOrbit.eulerAngles.x = Float(-Double.pi) * HeightRatio
            
            //for final check on fingers number
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
        
        if (gestureRecognize.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = WidthRatio
            lastHeightRatio = HeightRatio
        }
    }
    
    @objc func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        // Set zoom properties
        let minVelocity = CGFloat(0.10)
        let zoomDelta = 0.5
        
        // Only zoom when gesture changing and when velocity exceeds <minVelocity>
        if recognizer.state == .changed {
            // Ignore gesture on tiny movements
            if abs(recognizer.velocity) <= minVelocity {
                return
            }
            
            // If here, zoom in or out based on velocity
            let deltaFov = recognizer.velocity > 0 ? -zoomDelta : zoomDelta
            var newFov = camera.fieldOfView + CGFloat(deltaFov)
            
            // Make sure FOV remains within min and max values
            //if newFov <= minXFov {
              //  newFov = minXFov
            //} else if newFov >= maxXFov {
              //  newFov = maxXFov
            //}
            
            // Update FOV?
            if camera.fieldOfView != newFov {
                camera.fieldOfView = newFov
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
        scnView = self.view as? SCNView
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
    }
    func setupScene() {
        scnScene = SCNScene(named: "rockWall-2.scn")
        
        let serializer = SceneSerializer.init(scene: scnScene)
        let serialScene = serializer.serializeScene()
        let unserialScene = serializer.unserializeScene(serialScene: serialScene)
        
        scnScene = unserialScene
        
        scnView.scene = scnScene
        scnView.backgroundColor = UIColor.white
    }
    
    func setupCamera() {
        // 1
        cameraNode = scnScene.rootNode.childNode(withName: "cameraNode", recursively: true)
        // 2
        // 3
        camera = cameraNode.camera
        camera.automaticallyAdjustsZRange = true
        // 4
        //scnScene.rootNode.addChildNode(cameraNode)
        cameraOrbit=SCNNode()
        //camera = SCNCamera()
        cameraOrbit.addChildNode(cameraNode)
        scnScene.rootNode.addChildNode(cameraOrbit)

        self.cameraOrbit.eulerAngles.y = Float(-2 * Double.pi) * lastWidthRatio
        self.cameraOrbit.eulerAngles.x = Float(-Double.pi) * lastHeightRatio

    }
    
    func nodeNearPoint(container:SCNScene, point:CGPoint) -> SCNNode {
        var result:SCNNode!
        var maxDistance = CGFloat.greatestFiniteMagnitude
        for node in container.rootNode.childNodes {
            if node.geometry is SCNSphere {
                let renderPos = scnView.projectPoint(node.position)
                let dx = point.x - CGFloat(renderPos.x)
                let dy = point.y - CGFloat(renderPos.y)
                print(renderPos.x)
                print(point.x)
                let distance = sqrt(dx*dx + dy*dy)
                if (distance <= maxDistance) {
                    maxDistance = distance
                    result = node
                    
                }
            }
        }
        return result
    }
}
