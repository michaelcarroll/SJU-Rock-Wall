//
//  OverlayScene.swift
//  SJU-Rock-Wall
//
//  Created by Tran, Anh B on 11/27/18.
//  Copyright © 2018 Tran, Anh B. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit
import UIKit

class OverlayScene: SKScene{
    let footButton = SKSpriteNode(imageNamed: "footButton")
    let handButton = SKSpriteNode(imageNamed: "handButton")
    let bothButton = SKSpriteNode(imageNamed: "bothButton")
    let resetButton = SKSpriteNode(imageNamed: "resetButton")
    var tapHand = false
    var tapFoot = false
    var tapBoth = false
    var score = 0

    override init(size: CGSize) {
        super.init(size: size)
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtons(){
        footButton.name="footButton"
        footButton.position = CGPoint(x: 160, y: 150)
        footButton.isUserInteractionEnabled = false
        footButton.setScale(0.15)
        
        handButton.name="handButton"
        handButton.position = CGPoint(x: 60, y: 150)
        handButton.isUserInteractionEnabled = false
        handButton.setScale(0.15)
        
        bothButton.name="bothButton"
        bothButton.position = CGPoint(x: 260, y: 150)
        bothButton.isUserInteractionEnabled = false
        bothButton.setScale(0.15)
        
        resetButton.name="resetButton"
        resetButton.position = CGPoint(x: 360, y: 150)
        resetButton.isUserInteractionEnabled = false
        resetButton.setScale(0.15)
        
        self.addChild(footButton)
        self.addChild(handButton)
        self.addChild(bothButton)
        self.addChild(resetButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self) else { return }
        print("tap2d")

        if self.handButton.contains(location) {
            print("taphand")
            if !tapHand {
                
                print("taphand")
                self.handButton.texture = SKTexture(imageNamed: "tapHand")
                self.footButton.texture = SKTexture(imageNamed: "footButton")
                self.bothButton.texture = SKTexture(imageNamed: "bothButton")
            }
            else {
                self.handButton.texture = SKTexture(imageNamed: "handButton")
            }
            tapHand = !tapHand
        }
        
        if self.footButton.contains(location) {
            if !tapFoot {
                print("tapfoot")
                self.footButton.texture = SKTexture(imageNamed: "tapFoot")
                self.bothButton.texture = SKTexture(imageNamed: "bothButton")
                self.handButton.texture = SKTexture(imageNamed: "tapHand")
            }
            else {
                self.footButton.texture = SKTexture(imageNamed: "footButton")
            }
            tapFoot = !tapFoot
        }
        
        if self.bothButton.contains(location) {
            if !tapBoth {
                print("tapboth")
                self.bothButton.texture = SKTexture(imageNamed: "bothTap")
                self.footButton.texture = SKTexture(imageNamed: "footButton")
                self.handButton.texture = SKTexture(imageNamed: "tapHand")
            }
            else {
                self.bothButton.texture = SKTexture(imageNamed: "bothButton")
            }
            tapBoth = !tapBoth
        }
    }
}
