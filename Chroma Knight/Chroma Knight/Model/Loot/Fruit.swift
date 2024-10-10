//
//  Fruits.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 28/07/24.
//

import Foundation
import SpriteKit

class Fruit {
    let node: SKSpriteNode
    init(size: CGSize) {
        self.node = SKSpriteNode(imageNamed: "fruits0")
        self.node.size = CGSize(width: size.height/25, height: size.height/25)
        let textures = [SKTexture(imageNamed: "fruits0"), SKTexture(imageNamed: "fruits1"), SKTexture(imageNamed: "fruits2"), SKTexture(imageNamed: "fruits3"), SKTexture(imageNamed: "fruits4"), SKTexture(imageNamed: "fruits5"), SKTexture(imageNamed: "fruits6")]
        self.node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)))
        
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategory.fruits
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player
        addBlinkingAndRemovalAction()
        node.zPosition = 4
    }
    
    private func addBlinkingAndRemovalAction() {
        let wait = SKAction.wait(forDuration: 10)
        let blinkOn = SKAction.colorize(with: .white, colorBlendFactor: 0.8, duration: 0.2)
        let blinkOff = SKAction.colorize(with: .clear, colorBlendFactor: 0.0, duration: 0.2)
        let blinkSequence = SKAction.sequence([blinkOn, blinkOff])
        let blinkRepeat = SKAction.repeat(blinkSequence, count: 5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([wait, blinkRepeat, remove])
        
        node.run(sequence)
    }
}
