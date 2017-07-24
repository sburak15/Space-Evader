//
//  specialMeteor.swift
//  SpaceEvader
//
//  Created by iD Student on 7/24/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//
import SpriteKit
import Foundation

class SpecialMeteor : Enemy {
    
    
    override init(imageNamed: String) {
    
        super.init(imageNamed: imageNamed)
        
        health = 3
        scoreAdd = 3
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
