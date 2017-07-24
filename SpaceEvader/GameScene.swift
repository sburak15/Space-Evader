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
    
    var meteorScore = 0
    
    var scoreLabel = SKLabelNode(fontNamed: "Arial")

    var level = 1
    var levelLabel = SKLabelNode(fontNamed: "Arial")
    var levelLimit = 10
    var levelIncrease = 10
    
    var enemies = [SKSpriteNode]()
    
    var gameIsRunning: Bool = true
    
    var meteorTime = 5.0
    
    var button: SKNode! = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))

    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
    func background() {
        
        let bg = SKSpriteNode(imageNamed: "background")
        bg.zPosition = 1
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = CGSize(width: size.width, height: size.height)
        addChild(bg)
        
    }
    
    
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
        
        background()
        
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
        hero.zPosition = 6
        
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
        
        addEnemies()
        
        addSpecialMeteors()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        scoreLabel.fontColor = UIColor.white
        
        scoreLabel.fontSize = 40
        
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height-50)
        
        scoreLabel.zPosition = 6
        
        addChild(scoreLabel)
        
        scoreLabel.text = "Score: \(meteorScore)"
        
        levelLabel.fontColor = UIColor.yellow
        
        levelLabel.fontSize = 20
        
        levelLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.9)
        
        levelLabel.zPosition = 6
        
        addChild(levelLabel)
        
        levelLabel.text = "Level: 1"
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
        meteor.zPosition = 6
        
        addChild(meteor)
        
        enemies.append(meteor)
        
        let moveMeteor = SKAction.move(to: CGPoint(x: -meteor.size.width/2, y: randomY), duration: meteorTime)
        
        meteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))
    }
    
    func addSpecialMeteor() {
        
        var specialMeteor : SpecialMeteor
        
        specialMeteor = SpecialMeteor(imageNamed: "SpecialMeteor")
        
        specialMeteor.size.height = 80
        specialMeteor.size.width = 95
        
        let randomY = random() * ((size.height - specialMeteor.size.height/2)-specialMeteor.size.height/2) + specialMeteor.size.height/2
        
        specialMeteor.position = CGPoint(x: size.width + specialMeteor.size.width/2, y: randomY)
        
        specialMeteor.physicsBody = SKPhysicsBody(rectangleOf: specialMeteor.size)
        specialMeteor.physicsBody?.isDynamic = true
        specialMeteor.physicsBody?.categoryBitMask = BodyType.Meteor
        specialMeteor.physicsBody?.contactTestBitMask = BodyType.Bullet
        specialMeteor.physicsBody?.collisionBitMask = 0
        specialMeteor.zPosition = 6
        
        addChild(specialMeteor)
        
        enemies.append(specialMeteor)
        
        let moveMeteor = SKAction.move(to: CGPoint(x: -specialMeteor.size.width/2, y: randomY), duration: meteorTime)
        
        specialMeteor.run(SKAction.sequence([moveMeteor, SKAction.removeFromParent()]))

        
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

       if gameIsRunning {
        
            let bullet = SKSpriteNode()
        
            bullet.color = UIColor.yellow
            bullet.size = CGSize(width: 5, height: 5)
        
            bullet.position = CGPoint(x: hero.position.x, y: hero.position.y)
        
            bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
            bullet.physicsBody?.isDynamic = true
            bullet.physicsBody?.categoryBitMask = BodyType.Bullet
            bullet.physicsBody?.contactTestBitMask = BodyType.Meteor
            bullet.physicsBody?.collisionBitMask = 0
            bullet.physicsBody?.usesPreciseCollisionDetection = true
            bullet.zPosition = 6
        
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
        
        else {
        
            let touchalso = touches.first
            let touchLocationAlso = touchalso!.location(in: self)

            if button.contains(touchLocationAlso) {
                removeAllChildren()
                addChild(hero)
                addEnemies()
                addSpecialMeteors()
                meteorScore = 0
                addChild(scoreLabel)
                level = 1
                addChild(levelLabel)
                gameIsRunning = true
                background()
            
            }
        
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let contactA = bodyA.categoryBitMask
        let contactB = bodyB.categoryBitMask
        

        switch contactA {
            
        case BodyType.Meteor:
            
            switch contactB {
                
            case BodyType.Meteor:
                
                break
                
            case BodyType.Bullet:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    bulletHitMeteor(bullet: bodyBNode, meteor: bodyANode)
                    
                }
                
            case BodyType.Hero:
                
                if let bodyBNode = contact.bodyB.node as? SKSpriteNode, let bodyANode = contact.bodyA.node as? Enemy {
                    
                    heroHitMeteor(player: bodyBNode, meteor: bodyANode)
                    
                }
                
            default:
                
                break
                
            }
        
        case BodyType.Bullet:
            
            switch contactB {
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    bulletHitMeteor(bullet: bodyANode, meteor: bodyBNode)
                    
                }
                
            case BodyType.Bullet:
                
                break
                
            case BodyType.Hero:
                
                break
                
            default:
                
                break
                
            }
            
        case BodyType.Hero:
            
            switch contactB {
                
            case BodyType.Meteor:
                
                if let bodyANode = contact.bodyA.node as? SKSpriteNode, let bodyBNode = contact.bodyB.node as? Enemy {
                    
                    heroHitMeteor(player: bodyANode, meteor: bodyBNode)
                    
                }           
                
            case BodyType.Bullet:
                
                break
                
            case BodyType.Hero:
                
                break
                
            default:
                
                break
                
            }
            
        default:
            
            break
        }
    }
    
    func bulletHitMeteor(bullet: SKSpriteNode, meteor: Enemy) {
        
        bullet.removeFromParent()

        meteor.health -= 1
        
        
        if meteor.health == 0 {
            
            meteor.removeFromParent()
        
            meteorScore += meteor.scoreAdd
        
            scoreLabel.text = "Score: \(meteorScore)"
        
            explodeMeteor(meteor: meteor)
        
            checkLevelIncrease()
        
            if let meteorIndex = enemies.index(of: meteor) {
            enemies.remove(at: meteorIndex)
        
            }
            
        }
        
        else {
            
            meteor.size.height -= 15
            
            meteor.size.width -= 15
            
        }
    
    }
    
    func reset() {
        
        let scoreOverLabel = SKLabelNode(fontNamed: "Arial")
        
        scoreOverLabel.text = "Score: \(meteorScore)"
        
        scoreOverLabel.fontColor = UIColor.white
        
        scoreOverLabel.fontSize = 40
        
        scoreOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        scoreOverLabel.zPosition = 6
        
        scoreLabel.text = "Score: 0"
        
        levelLabel.text = "Level: 1"
        
        levelLimit = 10
        
        levelIncrease = 10
        
        meteorTime = 5.0
        
        addChild(scoreOverLabel)
        
        stopEnemies()
        
        createButton()
        
        gameIsRunning = false
        
        background()
    }
    
    func heroHitMeteor(player: SKSpriteNode, meteor: SKSpriteNode) {
        
        removeAllChildren()
        
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        
        gameOverLabel.text = "Game Over"
        
        gameOverLabel.fontColor = UIColor.white
        
        gameOverLabel.fontSize = 40
        
        gameOverLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 50)
        
        gameOverLabel.zPosition = 6
        
        addChild(gameOverLabel)
        
        reset()
        
        }
    
    func explodeMeteor(meteor: SKSpriteNode) {
        
        let explosions: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        for explosion in explosions {
        
            explosion.color = UIColor.orange
            explosion.size = CGSize(width: 3, height: 3)
            explosion.position = CGPoint(x: meteor.position.x, y: meteor.position.y)
            explosion.zPosition = 6
            
            let randomExplosionX = (random() * (1000 + size.width)) - size.width
            
            let randomExplosionY = (random() * (1000 + size.height)) - size.width
            
            let moveExplosion: SKAction = SKAction.move(to: CGPoint(x: randomExplosionX, y: randomExplosionY), duration: 10.0)
            explosion.run(SKAction.sequence([moveExplosion, SKAction.removeFromParent()]))
            
            addChild(explosion)
        
        }

    }
    
    func addEnemies() {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor), SKAction.wait(forDuration: 0.75)])), withKey:"addEnemies")
    }
    
    func addSpecialMeteors() {
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 7), SKAction.run(self.addSpecialMeteor)])), withKey: "addSpecialMeteors")
        
    }
    
    func stopEnemies() {
        
        for enemy in enemies {
            enemy.removeFromParent()
        }
        
        removeAction(forKey: "addEnemies")
        
        removeAction(forKey: "addSpecialMeteors")

    }
    
    func createButton() {
        
        button.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 45)
        
        let buttonLabel = SKLabelNode(fontNamed: "Arial")
      
        buttonLabel.text = "Play Again"
        
        buttonLabel.fontColor = UIColor.white
        
        buttonLabel.fontSize = 20
        
        buttonLabel.position = CGPoint(x: self.frame.midX, y:self.frame.midY - 52)
        
        button.zPosition = 6
        
        buttonLabel.zPosition = 6
    
        addChild(button)
        
        addChild(buttonLabel)
        
    }
    
    func youWin() {
        
        removeAllChildren()
        
        let youWinLabel = SKLabelNode(fontNamed: "Arial")
        
        youWinLabel.text = "You Win!"
        
        youWinLabel.fontColor = UIColor.white
        
        youWinLabel.fontSize = 40
        
        youWinLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 50)
        
        youWinLabel.zPosition = 6
        
        addChild(youWinLabel)
        
        reset()
    }
    
    func increaseLevel() {
        
        levelLimit += levelIncrease
        
        level += 1
        
        levelLabel.text = "Level: \(level)"
        
        meteorTime -= 0.5
        
    }
    
    func checkLevelIncrease() {
        
        if meteorScore != 100 {
            
            if meteorScore >= levelLimit {
                
                for enemy in enemies {
                    enemy.removeFromParent()
                }
                
                enemies = [Enemy] ()
                
                let runEnemies = SKAction.sequence([SKAction.run(stopEnemies), SKAction.wait(forDuration: 3.0), SKAction.run(increaseLevel), SKAction.run(addEnemies), SKAction.run(addSpecialMeteors)])
                run(runEnemies)
            }
            
        }
            
        else {
            
            youWin()
        }

    }
    
   

}
