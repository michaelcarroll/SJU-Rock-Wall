//
//  SerializeScene.swift
//  SJU-Rock-Wall
//
//  Created by Alseth, Colton D on 10/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//
import Foundation
import SceneKit

class SceneSerializer {
    private var theScene: SCNScene
    
    // function to serialize a .scn file
    public func serializeScene() -> String {
        let serial = NSKeyedArchiver.archivedData(withRootObject: theScene).base64EncodedString()
        return serial
        
        
    }
    
    // function to unserialize a data file back into a .scn
    public func unserializeScene(serialScene: String) -> SCNScene {
        
        let data = NSData(base64Encoded: serialScene, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        
        
        if let loadedScene = NSKeyedUnarchiver.unarchiveObject(with: data! as Data) as? SCNScene{
             theScene = loadedScene
        }
        return theScene
    }
    
    // initialize the SceneSerializer class by passing it a .scn file
    init(scene: SCNScene){
        theScene = scene
    }
}
