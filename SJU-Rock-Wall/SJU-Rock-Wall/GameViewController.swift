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
    var cameraOrbit: SCNNode!
    var cameraNode: SCNNode!
    var wall: SCNNode!
    var wedge: SCNNode!
    var text: SCNNode!
    var sphere: SCNNode!
    var radius: CGFloat!
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
        setupCamera()
        // retrieve the wall node
        wall = scnScene.rootNode.childNode(withName: "wall", recursively: true)!
        // retrieve the wedge node
        wedge = scnScene.rootNode.childNode(withName: "wedge", recursively: true)!
        // retrieve the text node
        text = scnScene.rootNode.childNode(withName: "text", recursively: true)!
        //retrieve a sphere
        sphere = scnScene.rootNode.childNode(withName: "sphere1", recursively: true)
        radius = (sphere.geometry as? SCNSphere)?.radius
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // add a tap gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        // add a pinch gesture recognizer
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: Selector(("handlePinch:")))
        scnView.addGestureRecognizer(pinchGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer)
    {
        let p = gestureRecognize.location(in: scnView)
        //let hitResults = scnView.hitTest(p, options: nil)
        let hitResults = self.nodesNearPoint(container: scnScene, point: p, maxDist: 0.5)
        print(hitResults.count)
        if hitResults.count > 0 {
            let result = hitResults[0]
            if((result.geometry!.firstMaterial?.emission.contents! as AnyObject).isEqual(UIColor.red))
            {
                result.geometry!.firstMaterial!.emission.contents = UIColor.black
            }
            else
            {
                result.geometry!.firstMaterial!.emission.contents = UIColor.red
            }
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
            
            self.cameraOrbit.eulerAngles.y = Float(-5 * Double.pi) * WidthRatio
            self.cameraOrbit.eulerAngles.x = Float(-2 * Double.pi) * HeightRatio
            
            //for final check on fingers number
            lastFingersNumber = fingersNeededToPan
        }
        
        lastFingersNumber = (numberOfTouches>0 ? numberOfTouches : lastFingersNumber)
        
        if (gestureRecognize.state == .ended && lastFingersNumber==fingersNeededToPan) {
            lastWidthRatio = WidthRatio
            lastHeightRatio = HeightRatio
        }
    }
    
    func handlePinch(gestureRecognize: UIPinchGestureRecognizer) {
        let pinchVelocity = Double.init(gestureRecognize.velocity)
        //print("PinchVelocity \(pinchVelocity)")
        
        camera.orthographicScale -= (pinchVelocity/pinchAttenuation)
        
        if camera.orthographicScale <= 0.5 {
            camera.orthographicScale = 0.5
        }
        
        if camera.orthographicScale >= 10.0 {
            camera.orthographicScale = 10.0
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
        scnScene = SCNScene(named: "rockWall.scn")
        scnView.scene = scnScene
        scnView.backgroundColor = UIColor.white
    }
    
    func setupCamera() {
        // 1
        cameraNode = SCNNode()
        // 2
        // 3
        camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 9
        camera.zNear = 1
        camera.zFar = 100
        cameraNode.camera = camera
        // 4
        //scnScene.rootNode.addChildNode(cameraNode)
        cameraOrbit=SCNNode()
        //camera = SCNCamera()
        cameraOrbit.addChildNode(cameraNode)
        scnScene.rootNode.addChildNode(cameraOrbit)

        self.cameraOrbit.eulerAngles.y = Float(-2 * Double.pi) * lastWidthRatio
        self.cameraOrbit.eulerAngles.x = Float(-Double.pi) * lastHeightRatio

    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        let scnurl = URL(fileURLWithPath: "Assets.xcassets/rockWall.scn")
        if(scnurl.isFileURL){
            print("is URL")
        }
        let test = (try? scnurl.checkResourceIsReachable()) ?? false
        
        if(test){
            print("pass")
        }
        if(scnurl.hasDirectoryPath){
            print("has path")
        }
        if(scnScene.write(to: scnurl, options: nil, delegate: nil, progressHandler: nil)){
            print("tis success")
        }
        print("This button work")
        var state = UIImage()
        state  =  scnView.snapshot()
        let jpgData = UIImageJPEGRepresentation(state, 0.8)
        print(jpgData!)
    }
    
    func nodesNearPoint(container: SCNScene, point: CGPoint, maxDist: CGFloat) -> [SCNNode] {
        var array = [SCNNode]()
        let pointWithDepth = SCNVector3Make(Float(point.x), Float(point.y), 0)
        let worldPoint = scnView.unprojectPoint(pointWithDepth)
        for node in container.rootNode.childNodes {
                if node.geometry is SCNSphere{
                    let dx = worldPoint.x - node.position.x
                    let dy = worldPoint.y - node.position.y
                
                    let distance = (dx*dx + dy*dy).squareRoot()
                    print(distance)
                    if (CGFloat(distance) <= maxDist){
                        array.append(node)
                    }
                }
        }
        return array
    }
    
}
