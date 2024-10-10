//
//  Slime.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 18/07/24.
//

import Foundation
import SpriteKit

class Slime: Enemy {
    init(hp: Int, damage: Int, speed: CGFloat, level: Int) {
        let textures = [SKTexture(imageNamed: "slimeWlk3"), SKTexture(imageNamed: "slimeWlk0"), SKTexture(imageNamed: "slimeWlk1"), SKTexture(imageNamed: "slimeWlk2")]
        super.init(node: SKSpriteNode(imageNamed: "slimeSTD"), hp: hp, damage: damage, textures: textures, speed: speed)
        node.size = CGSize(width: 1024/20, height: 832/20)
        node.color = generateColor(level: level)
        node.colorBlendFactor = 1
        animateWlk()
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.friction = 1
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = PhysicsCategory.slime
        node.physicsBody?.collisionBitMask = PhysicsCategory.ground | PhysicsCategory.player
        node.physicsBody?.contactTestBitMask = PhysicsCategory.ground | PhysicsCategory.player
        node.zPosition = 2
    }
    override func moveEnemy(direction: CGFloat) {
        if(!movCD && !dmgCD) {
            node.xScale = CGFloat(direction)
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * 1.5 * direction, dy: 35))
            movCD = true
            let toggleMov = SKAction.run {
                self.movCD = false
            }
            node.run(SKAction.sequence([SKAction.wait(forDuration: 1), toggleMov]), withKey: "movement")
        }
    }
    func impulse(xForce: CGFloat) {
        node.physicsBody?.velocity = CGVector.zero
        node.physicsBody?.applyImpulse(CGVector(dx: xForce, dy: 25))
    }
    override func takeDamage(direction: CGFloat, damage: Int) -> Bool {
        if(!dmgCD) {
            dmgCD = true
            node.texture = SKTexture(imageNamed: "slimeDmg")
            node.colorBlendFactor = 0
            node.removeAction(forKey: "movement")
            node.removeAction(forKey: "animation")
            node.physicsBody?.velocity = CGVector.zero
            node.physicsBody?.applyImpulse(CGVector(dx: speed * direction, dy: 25))
            hp -= damage
            if(hp <= 0) {
                self.node.physicsBody?.categoryBitMask = PhysicsCategory.none
                self.node.physicsBody?.collisionBitMask = PhysicsCategory.none
                self.node.physicsBody?.contactTestBitMask = PhysicsCategory.none
                node.run(SKAction.fadeOut(withDuration: 1)) {
                    self.node.removeFromParent()
                }
                return true
            } else {
                node.run(SKAction.wait(forDuration: 1)) {
                    self.dmgCD = false
                    self.movCD = false
                    self.node.colorBlendFactor = 1
                    self.animateWlk()
                }
                return false
            }
        } else {
            return false
        }
    }
    override func animateWlk() {
        node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)), withKey: "animation")
    }
}
func generateColor(level: Int) -> UIColor {
    switch level {
    case 1:
        return .cyan
    case 2:
        return UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)   // Orange
    case 3:
        return UIColor(red: 255/255, green: 223/255, blue: 0/255, alpha: 1)   // Yellow
    case 4:
        return UIColor(red: 148/255, green: 0/255, blue: 211/255, alpha: 1)   // Purple
    case 5:
        return UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1)     // Green
    case 6:
        return UIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1) // Pink
    default:
        return UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1)     // Blue
    }
}

