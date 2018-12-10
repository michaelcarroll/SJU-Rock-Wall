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
import SpriteKit

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
    var tapHand = false
    var tapFoot = false
    var tapBoth = false
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
    var spriteScene: OverlayScene!
    
    //HANDLE PINCH CAMERA
    var pinchAttenuation = 20.0  //1.0: very fast ---- 100.0 very slow
    var lastFingersNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        self.spriteScene = OverlayScene(size: self.view.bounds.size)
        self.spriteScene.isUserInteractionEnabled = false
        
        self.scnView.overlaySKScene = self.spriteScene
        //self.view.addSubview(self.scnView)
        // retrieve the wall node
        wall = scnScene.rootNode.childNode(withName: "wall", recursively: true)!
        // retrieve the wedge node
        wedge = scnScene.rootNode.childNode(withName: "wedge", recursively: true)!
        
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //scnView.addGestureRecognizer(tapGesture)
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
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var p = touches.first?.location(in: spriteScene)
        if spriteScene.handButton.contains(p!) {
            if (tapHand==false) {
                spriteScene.handButton.texture = SKTexture(imageNamed: "tapHand")
                spriteScene.footButton.texture = SKTexture(imageNamed: "footButton")
                spriteScene.bothButton.texture = SKTexture(imageNamed: "bothButton")
                tapHand=true
                tapBoth=false
                tapFoot=false
            }
            else {
                spriteScene.handButton.texture = SKTexture(imageNamed: "handButton")
                tapHand=false
            }
        }
        
        else if spriteScene.footButton.contains(p!) {
            if (tapFoot==false) {
                spriteScene.footButton.texture = SKTexture(imageNamed: "tapFoot")
                spriteScene.bothButton.texture = SKTexture(imageNamed: "bothButton")
                spriteScene.handButton.texture = SKTexture(imageNamed: "handButton")
                tapFoot=true
                tapHand=false
                tapBoth=false
            }
            else {
                spriteScene.footButton.texture = SKTexture(imageNamed: "footButton")
                tapFoot = false
            }
        }
        
        else if spriteScene.bothButton.contains(p!) {
            if (tapBoth==false){
                spriteScene.bothButton.texture = SKTexture(imageNamed: "bothTap")
                spriteScene.footButton.texture = SKTexture(imageNamed: "footButton")
                spriteScene.handButton.texture = SKTexture(imageNamed: "handButton")
                tapBoth = true
                tapHand = false
                tapFoot = false
            }
            else {
                spriteScene.bothButton.texture = SKTexture(imageNamed: "bothButton")
                tapBoth = false
            }
        }
            
        else if spriteScene.resetButton.contains(p!){
            for node in scnScene.rootNode.childNodes{
                if node.geometry is SCNSphere{
                    node.geometry!.firstMaterial!.diffuse.contents=UIColor.white
                }
            }
        }
        else{
            p = touches.first?.location(in: scnView)
            let result = nodeNearPoint(container: scnScene, point: p!)
            if(tapFoot)
            {
                if((result.geometry!.firstMaterial?.diffuse.contents! as AnyObject).isEqual(UIColor.yellow)){
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.white
                }
                else{
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.yellow
                }
            }
            else if(tapBoth)
            {
                if((result.geometry!.firstMaterial?.diffuse.contents! as AnyObject).isEqual(UIColor.orange)){
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.white
                }
                else{
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.orange
                    //result.geometry!.firstMaterial!.emission.contents = UIColor.orange
                }
                
            }
            else if(tapHand)
            {
                if(result.geometry!.firstMaterial?.diffuse.contents! as AnyObject).isEqual(UIColor.red){
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.white
                }
                else{
                    result.geometry!.firstMaterial!.diffuse.contents = UIColor.red
                }
                
            }
            else
            {
                result.geometry!.firstMaterial!.diffuse.contents = UIColor.white
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
        scnView.scene = scnScene
        // 1
        scnView.showsStatistics = true
        // 2
        scnView.allowsCameraControl = true
        // 3
        scnView.autoenablesDefaultLighting = true
        scnView.defaultCameraController
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "rockWall-2.scn")
        
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
