//
//  SerializeScene.swift
//  SJU-Rock-Wall
//
//  Created by Alseth, Colton D on 10/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import SceneKit

class SceneSerializer{

    private var theScene: SCNScene
    
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("Scene").path)
    }
    
    public func getFilePath() -> String{
        return filePath
    }
    
    public func serializeScene() -> Bool {
        return NSKeyedArchiver.archiveRootObject(theScene, toFile: filePath)
    }
    
    public func unserializeScene() -> SCNScene {
        if let loadedScene = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? SCNScene{
            theScene = loadedScene
        }
        return theScene
    }
    
    init(scene: SCNScene){
        theScene = scene
    }
}
