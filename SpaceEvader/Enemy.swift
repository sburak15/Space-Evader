//
//  Enemy.swift
//  SpaceEvader
//
//  Created by iD Student on 7/19/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//


import SpriteKit

class Enemy: SKSpriteNode {
    
    var health = 1
    
    var scoreAdd: Int
    
    init(imageNamed: String) {
        
        let texture = SKTexture(imageNamed: "\(imageNamed)")
        
        scoreAdd = 1
        
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
