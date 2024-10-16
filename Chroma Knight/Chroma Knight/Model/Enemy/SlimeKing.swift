//
//  SlimeKing.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 26/07/24.
//

import Foundation
import SpriteKit

class SlimeKing {
    var hp = 3
    var damageCD: Bool = true
    var isAlive = false
    
    let node: SKSpriteNode
    let fist: SKSpriteNode
    
    var fistDmgCD = true
    var isFistAttacking = false
    
    var spawnTextures: [SKTexture] = []
    var animateTextures: [SKTexture] = []
    var damageTextures: [SKTexture] = []
    var tiredTextures: [SKTexture] = []
    var fistTextures: [SKTexture] = []
    let size: CGSize
    
    init(size: CGSize){
        self.size = size
        node = SKSpriteNode(imageNamed: "SlimeKingSpawn1")
        node.size = CGSize(width: 1024/7, height: 1024/7)
        node.position = CGPoint(x: size.width/2, y: size.height/2 - 4)
        
        fist = SKSpriteNode(imageNamed: "SlimeFist1")
        fist.size = CGSize(width: 1024/10, height: 802/10)
        fist.position = CGPoint(x: fist.size.width, y: size.height/2)
        
        
        for i in 1..<5 {
            spawnTextures.append(SKTexture(imageNamed: "SlimeKingSpawn\(i)"))
        }
        
        for i in 1..<4 {
            animateTextures.append(SKTexture(imageNamed: "SlimeKingAnimate\(i)"))
        }
        animateTextures.append(SKTexture(imageNamed: "SlimeKingAnimate2"))
        print(animateTextures)
        
        for i in 1..<3 {
            damageTextures.append(SKTexture(imageNamed:  "SlimeKingDmg\(i)"))
        }
        
        for i in 1..<3{
            tiredTextures.append(SKTexture(imageNamed: "SlimeKingTired\(i)"))
        }
        
        for i in 1..<4 {
            fistTextures.append(SKTexture(imageNamed: "SlimeFist\(i)"))
        }
    }
        
    func spawnAnimation() {
        vibrate(with: .heavy)
        node.run(SKAction.repeatForever(SKAction.animate(with: spawnTextures, timePerFrame: 2/TimeInterval(spawnTextures.count), resize: false, restore: false)), withKey: "animation")
    }
    
    func animateSlimeKing() {
        node.run(SKAction.repeatForever(SKAction.animate(with: animateTextures, timePerFrame: 1.5/TimeInterval(animateTextures.count), resize: false, restore: false)), withKey: "animation")
    }
    
    func animateTired() {
        node.run(SKAction.repeatForever(SKAction.animate(with: tiredTextures, timePerFrame: 1.5/TimeInterval(tiredTextures.count), resize: false, restore: false)), withKey: "animation")
    }
    
    func takeDamage() -> Bool {
        damageCD = true
        vibrate(with: .medium)
        hp -= 1
        node.run(SKAction.repeatForever(SKAction.animate(with: damageTextures, timePerFrame: 1/TimeInterval(damageTextures.count), resize: false, restore: false)), withKey: "animation")
        transitionToIdle()
        return !checkIsAlive()
    }
    
    func checkIsAlive() -> Bool {
        if(hp < 1) {
            isAlive = false
            despawn()
            fist.removeAllActions()
            fist.removeFromParent()
            return false
        }
        return true
    }
    
    func despawn() {
        node.run(SKAction.fadeOut(withDuration: 1)) {
            self.node.removeAllActions()
            self.node.removeFromParent()
        }
    }
    
    func slimeAttack() {
        if let scene = node.parent as? LevelOneScene {
            for i in 0...5 {
                let newSlime = Slime(hp: 1, damage: 1, speed: 8, level: 1)
                let side = Bool.random()
                newSlime.node.position = CGPoint(x: side ? (newSlime.node.size.width * CGFloat(i)) : scene.size.width - (newSlime.node.size.width * CGFloat(i)), y: scene.size.height - 150)
                newSlime.node.color = generateColor(level: Int.random(in: 1...6))
                newSlime.impulse(xForce: side ? 5 : -5)
                scene.addChild(newSlime.node)
                scene.slimes.append(newSlime)
            }
        }
    }
    
    func fistAttack() {
        isFistAttacking = true
        let side = Bool.random()
        fist.position = CGPoint(x: side ? 0 + fist.size.width/2 : size.width - fist.size.width/2, y: size.height/2 - fist.size.height/2)
        fist.xScale = side ? 1 : -1
        fist.alpha = 0
        node.parent?.addChild(fist)
        let spawn = SKAction.fadeIn(withDuration: 1.5)
        let dmgCDFalse = SKAction.run {
            self.fistDmgCD = false
        }
        let dmgCDTrue = SKAction.run {
            self.fistDmgCD = true
        }
        let move = SKAction.move(to: side ? CGPoint(x: size.width + fist.size.width, y: fist.position.y) : CGPoint(x: 0 - fist.size.width, y: fist.position.y), duration: 3)
        let despawn = SKAction.run {
            self.isFistAttacking = false
            self.fist.removeAllActions()
            self.fist.removeFromParent()
        }
        fist.run(SKAction.sequence([spawn, dmgCDFalse, move, dmgCDTrue, despawn]))
        animateFist()
    }
    
    
    func spawn() {
        isAlive = true
        node.alpha = 0
        node.run(SKAction.fadeIn(withDuration: 1)) {
            self.spawnAnimation()
            self.transitionToIdle()
        }
    }
    
    func transitionToIdle() {
        let wait = SKAction.wait(forDuration: 1)
        let idle = SKAction.run { [weak self] in
            self?.idle()
        }
        node.run(SKAction.sequence([wait, idle]))
    }
    
    func animateFist() {
        fist.run(SKAction.repeatForever(SKAction.animate(with: fistTextures, timePerFrame: 1/TimeInterval(fistTextures.count), resize: false, restore: false)))
    }
    
    func idle() {
        node.run(SKAction.repeatForever(SKAction.animate(with: animateTextures, timePerFrame: 1.5/TimeInterval(animateTextures.count), resize: false, restore: false)), withKey: "animation")
        let wait = SKAction.wait(forDuration: 5)
        let attackSlimes = SKAction.run { [weak self] in
            self?.slimeAttack()
        }
        let attackFist = SKAction.run { [weak self] in
            self?.fistAttack()
        }
//
//        let randomAttack = SKAction.run { [weak self] in
//            if Bool.random() {
//                self?.slimeAttack()
//            } else {
//                self?.fistAttack()
//            }
//        }
        let toggleWeakPoint = SKAction.run { [weak self] in
            self?.animateTired()
            self?.damageCD = false
        }
        node.run(SKAction.repeatForever(SKAction.sequence([wait, attackSlimes, wait, attackFist, wait, toggleWeakPoint])), withKey: "idle")
    }
}
