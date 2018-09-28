//
//  ShapeType.swift
//  SJU-Rock-Wall
//
//  Created by Tran, Anh B on 9/24/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation

// 1
public enum ShapeType:Int {
    
    case Box = 0
    case Sphere = 1
    case Pyramid = 2
    case Torus = 3
    case Capsule = 4
    case Cylinder = 5
    case Cone = 6
    case Tube = 7
    
    // 2
    static func random() -> ShapeType {
        let maxValue = Tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }
}
