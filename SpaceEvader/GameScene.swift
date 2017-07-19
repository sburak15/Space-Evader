//
//  GameScene.swift
//  SpaceEvader
//
//  Created by iD Student on 7/19/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

struct BodyType {
    
    static let None: UInt32 = 0
    static let Meteor: UInt32 = 1
    static let Bullet: UInt32 = 2
    static let Hero: UInt32 = 4
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let hero = SKSpriteNode (imageNamed: "Spaceship")
    
    let heroSpeed: CGFloat = 100.0
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
    
    func swipedUp(sender:UISwipeGestureRecognizer){
        var actionMove: SKAction
        if (hero.position.y + heroSpeed >= size.height) {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: size.height - hero.size.height/2), duration:0.5)
        }
        else {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y + heroSpeed), duration: 0.5)
        }
        hero.run(actionMove)
    }
    
    func swipedDown(sender:UISwipeGestureRecognizer){
        var actionMove: SKAction
        if (hero.position.y - heroSpeed <= 0) {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.size.height/2), duration: 0.5)
        }
        else {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x, y: hero.position.y - heroSpeed), duration: 0.5)
        }
        hero.run(actionMove)
    }
  
    func swipedLeft(sender:UISwipeGestureRecognizer){
        var actionMove: SKAction
        if (hero.position.x - heroSpeed <= 0) {
            actionMove = SKAction.move(to: CGPoint(x: hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
            actionMove = SKAction.move(to: CGPoint(x: hero.position.x - heroSpeed, y: hero.position.y), duration: 0.5)
        }
        hero.run(actionMove)
    }
    
    func swipedRight(sender:UISwipeGestureRecognizer){
        var actionMove: SKAction
        if (hero.position.x + heroSpeed >= size.width) {
            actionMove = SKAction.move(to: CGPoint(x: size.width - hero.size.width/2, y: hero.position.y), duration: 0.5)
        }
        else {
        actionMove = SKAction.move(to: CGPoint(x: hero.position.x + heroSpeed, y: hero.position.y), duration: 0.5)
        }
        hero.run(actionMove)
    }
    
    override func didMove(to view: SKView) {
      
        backgroundColor = SKColor.black
        
        
        let xCoord = size.width * 0.5
        let yCoord = size.height * 0.5
        
        hero.size.height = 50
        hero.size.width = 50
        
        hero.position = CGPoint(x: xCoord, y: yCoord)
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.size)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.categoryBitMask = BodyType.Hero
        hero.physicsBody?.contactTestBitMask = BodyType.Meteor
        hero.physicsBody?.collisionBitMask = 0
        
        addChild(hero)

    
        let swipeUp: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedUp))
        
        swipeUp.direction = .up
        
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedDown))
        
        swipeDown.direction = .down
        
        view.addGestureRecognizer(swipeDown)
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        
        swipeLeft.direction = .left
        
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor), SKAction.wait(forDuration: 1.0)])))
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
    }
    
    func random() -> CGFloat {
        
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
    
    func addMeteor() {
        
        var meteor: Enemy
        
        meteor = Enemy(imageNamed: "MeteorLeft")
        
        meteor.size.height = 35
        meteor.size.width = 50
        
        let randomY = random() * ((size.height - meteor.size.height/2)-meteor.size.height/2) + meteor.size.height/2
        
        meteor.position = CGPoint(x: size.width + meteor.size.width/2, y: randomY)
        
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = BodyType.Meteor
        meteor.physicsBody?.contactTestBitMask = BodyType.Bullet
        meteor.physicsBody?.collisionBitMask = 0
        
        addChild(meteor)
        
        var moveMeteor = SKAction.move(to: CGPoint(x: -meteor.size.width/2, y: randomY), duration: 5.0)
        
        meteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
        let bullet = SKSpriteNode()
        
        bullet.color = UIColor.purple
        
        bullet.size = CGSize(width: 5, height: 5)
        
        bullet.position = CGPoint(x: hero.position.x, y: hero.position.y)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = BodyType.Bullet
        bullet.physicsBody?.contactTestBitMask = BodyType.Meteor
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(bullet)
        
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let vector = CGVector(dx: -(hero.position.x - touchLocation.x), dy: -(hero.position.y - touchLocation.y))
        
        let projectileAction = SKAction.sequence([
            SKAction.repeat(SKAction.move(by: vector, duration: 0.5), count: 10),
            SKAction.wait(forDuration: 0.5),
            SKAction.removeFromParent()
            ])
        
        bullet.run(projectileAction)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

}

