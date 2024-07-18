//
//  Slime.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 18/07/24.
//

import Foundation
import SpriteKit

class Slime: Enemy {
    init(hp: Int, damage: Int, speed: CGFloat) {
        let textures = [SKTexture(imageNamed: "slimeWlk3"), SKTexture(imageNamed: "slimeWlk0"), SKTexture(imageNamed: "slimeWlk1"), SKTexture(imageNamed: "slimeWlk2")]
        super.init(node: SKSpriteNode(imageNamed: "slimeSTD"), hp: hp, damage: damage, textures: textures, speed: speed)
        node.size = CGSize(width: 1024/20, height: 832/20)
        animateWlk()
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.friction = 1
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = PhysicsCategory.slime
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player
    }
    override func moveEnemy(direction: CGFloat) {
        if(!movCD) {
            node.xScale = CGFloat(direction)
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * 1.5 * direction, dy: 35))
            movCD = true
            node.run(SKAction.wait(forDuration: 1)) {
                self.movCD = false
            }
        }
    }
    override func takeDamage(direction: CGFloat) -> Bool {
        if(!dmgCD) {
            dmgCD = true
            node.texture = SKTexture(imageNamed: "slimeDmg")
            node.removeAllActions()
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * direction, dy: 25))
            hp -= 1
            if(hp <= 0) {
                node.run(SKAction.wait(forDuration: 1)) {
                    self.node.removeFromParent()
                }
                return true
            }
            node.run(SKAction.wait(forDuration: 1)) {
                self.dmgCD = false
                self.movCD = false
                self.moveEnemy(direction: direction * -1)
                self.animateWlk()
            }
        }
        return false
    }
    override func animateWlk() {
        node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)))
    }
}

