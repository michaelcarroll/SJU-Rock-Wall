//
//  File.swift
//  SJU-Rock-Wall
//
//  Created by Alseth, Colton D on 10/25/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import SceneKit

class CodableScene: Codable {
    
    private var theScene: SCNScene
    
    init(){
        
    }
    
    private func getScene() -> SCNScene {
        return theScene
    }
    
    private func setScene(scene: SCNScene) -> Bool {
        
    }
}
