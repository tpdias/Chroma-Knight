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
        self.sword.node.position = CGPoint(x: node.size.width/2, y: -node.size.height/4)
        self.sword.node.zPosition = 2
        self.node.addChild(self.sword.node)
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
        if isJumping { return }
        isJumping = true
        node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
    }
}
