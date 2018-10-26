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
    public func serializeScene() -> Data {
        return  NSKeyedArchiver.archivedData(withRootObject: theScene)
    }
    
    // function to unserialize a data file back into a .scn
    public func unserializeScene(serialScene: Data) -> SCNScene {
        if let loadedScene = NSKeyedUnarchiver.unarchiveObject(with: serialScene) as? SCNScene{
            theScene = loadedScene
        }
        return theScene
    }
    
    // initialize the SceneSerializer class by passing it a .scn file
    init(scene: SCNScene){
        theScene = scene
    }
}
