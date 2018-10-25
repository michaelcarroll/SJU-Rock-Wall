//
//  SerializeScene.swift
//  SJU-Rock-Wall
//
//  Created by Alseth, Colton D on 10/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import SceneKit

class SerializeScene{

    var ourScene: SCNScene
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        print("this is the url path in the documentDirectory \(String(describing: url))")
        
        return (url!.appendingPathComponent("Scene").path)
    }
    
    
    private func saveScene(theScene: SCNScene){
        NSKeyedArchiver.archiveRootObject(theScene, toFile: filePath)
    }
    
    private func loadScene(){
        if let loadedScene = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? SCNScene{
            ourScene = loadedScene
        }
    }
    
    init(){
        
    }
}
