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
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        
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
            node.size = CGSize(width: 809/15, height: 1024/15)
            node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)))
            sword.animateSwordStd(duration: 1/TimeInterval(textures.count))
        }
    }
    func animateWalk() {
        if(!isJumping) {
            node.size = CGSize(width: 927/15, height: 1024/15)
            node.run(SKAction.repeatForever(SKAction.animate(with: walkingTextures, timePerFrame: 1/TimeInterval(walkingTextures.count), resize: false, restore: false)))
            sword.animateSwordWalking(duration: 1/TimeInterval(walkingTextures.count))
        }
    }
    func movePlayer(distance: CGFloat) {
        node.position.x += distance
        if(distance <= 0) {
            node.xScale = -1.0
        } else {
            node.xScale = 1.0
        }
    }
    func playerJump() {
        node.size = CGSize(width: 809/15, height: 1024/15)
        node.texture = SKTexture(imageNamed: "playerJumping")

        node.removeAllActions()
        sword.node.removeAllActions()
        if isJumping { return }
        isJumping = true
        node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
    }
    
    func jumpAttack() {
        if(!isJumpAttacking) {
            sword.jumpAttack()
            node.removeAllActions()
            node.size = CGSize(width: 809/15, height: 1024/15)
            node.texture = SKTexture(imageNamed: "playerJumpAttack")
            isJumpAttacking = true
        }
    }
    func collideWithFloor() {
        sword.collideWithFloor()
        isJumping = false
        isJumpAttacking = false
    }
}
