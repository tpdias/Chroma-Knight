//
//  Player.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 18/06/24.
//

import Foundation
import SpriteKit

class Player {
    var node: SKSpriteNode
    var movementSpeed: CGFloat
    
    //jump
    var isJumping: Bool = false
    var jumpForce: CGFloat = 100.0
    
    //sword
    var sword: Sword
    //textures
    var textures: [SKTexture] = []
    var walkingTextures: [SKTexture] = []
    
    //jumpAttack
    var isJumpAttacking = false
    
    
    var hp: Int = 3
    var damageCD = false
    
    init(size: CGSize, sword: Sword) {
        self.movementSpeed = 2.0
        self.node = SKSpriteNode(imageNamed: "player0")
        node.size = CGSize(width: 809/15, height: 1024/15)
        node.position = CGPoint(x: size.width/2, y: (size.height / 2 - size.height / 3.4) + node.size.height)
        node.zPosition = 1
        node.name = "player"
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.player
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.slime
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.slime
        
        self.sword = sword
        self.sword.node.zPosition = 2
        self.node.addChild(self.sword.node)
        
        self.textures.append(SKTexture(imageNamed: "player0"))
        self.textures.append(SKTexture(imageNamed: "player1"))
        self.walkingTextures.append(SKTexture(imageNamed: "playerWlk0"))
        self.walkingTextures.append(SKTexture(imageNamed: "playerWlk1"))
        self.walkingTextures.append(SKTexture(imageNamed: "playerWlk2"))
        
        animatePlayer()
    }
    
    func animatePlayer() {
        if(!isJumping) {
            if(!damageCD) {
                node.size = CGSize(width: 809/15, height: 1024/15)
                node.removeAction(forKey: "animation")
                node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)), withKey: "animation")
            }
            sword.animateSwordStd(duration: 1/TimeInterval(textures.count))
        }
    }
    func animateWalk() {
        if(!isJumping) {
            if(!damageCD) {
                node.size = CGSize(width: 927/15, height: 1024/15)
                node.removeAction(forKey: "animation")
                node.run(SKAction.repeatForever(SKAction.animate(with: walkingTextures, timePerFrame: 1/TimeInterval(walkingTextures.count), resize: false, restore: false)), withKey: "animation")
                sword.animateSwordWalking(duration: 1/TimeInterval(walkingTextures.count))
            }
        }
    }
    func movePlayer(direction: CGFloat) {
        node.position.x += movementSpeed * direction
        node.xScale = direction
    }
    func playerJump() {
        if(!damageCD) {
            node.size = CGSize(width: 809/15, height: 1024/15)
            node.texture = SKTexture(imageNamed: "playerJumping")
        }
        if isJumping && !isJumpAttacking { return }
        isJumping = true
        impulsePlayer(force: jumpForce)
    }
    
    func impulsePlayer(force: CGFloat) {
        node.removeAction(forKey: "animation")
        sword.node.removeAllActions()
        node.physicsBody?.velocity = CGVector.zero
        node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: force))
    }
    
    func jumpAttack() {
        if(!isJumpAttacking) {
            sword.jumpAttack()
            if(!damageCD) {
                self.node.removeAction(forKey: "animation")
                node.size = CGSize(width: 809/15, height: 1024/15)
                node.texture = SKTexture(imageNamed: "playerJumpAttack")
            }
            isJumpAttacking = true
        }
    }
    func collideWithFloor() {
        sword.collideWithFloor()
        isJumping = false
        isJumpAttacking = false
    }
    func takeDamage(direction: CGFloat, damage: Int) {
        if(!damageCD) {
            hp -= damage
            node.removeAction(forKey: "animation")
            node.size = CGSize(width: 809/15, height: 1024/15)
            node.texture = SKTexture(imageNamed: "playerDmg")
            node.physicsBody?.velocity = CGVector.zero
            if(isJumping) {
                node.physicsBody?.applyImpulse(CGVector(dx: 30 * direction, dy: jumpForce))
            } else {
                node.physicsBody?.applyImpulse(CGVector(dx: 20 * direction, dy: 25))
            }
            damageCD = true
            let waitAction = SKAction.wait(forDuration: 1.05)
            let runAction = SKAction.run {
                self.damageCD = false
            }
            node.run(SKAction.sequence([waitAction, SKAction.run {
                self.animatePlayer()
            }]), withKey: "animate")
            let sequence = SKAction.sequence([waitAction, runAction])
            self.node.run(sequence, withKey: "damage")
        }
    }
}
