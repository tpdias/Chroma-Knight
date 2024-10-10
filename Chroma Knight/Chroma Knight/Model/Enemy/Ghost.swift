//
//  Ghost.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 18/07/24.
//

import Foundation
import SpriteKit

class Ghost: Enemy {
    let collisionNode: SKShapeNode
    
    init(hp: Int, damage: Int, speed: CGFloat) {
        let textures = [SKTexture(imageNamed: "ghost1"), SKTexture(imageNamed: "ghost0")]
        let tempNode = SKSpriteNode(texture: textures[1])
        
        collisionNode = SKShapeNode(circleOfRadius: 1024/45) // Ajuste o raio conforme necessário
        collisionNode.fillColor = .clear
        collisionNode.strokeColor = .clear
        collisionNode.zPosition = tempNode.zPosition + 1
        collisionNode.position = CGPoint(x: 0, y: 0)
        super.init(node: tempNode, hp: hp, damage: damage, textures: textures, speed: speed)
        node.size = CGSize(width: 1024/20, height: 981/20)
        node.run(SKAction.repeatForever(SKAction.animate(with: textures, timePerFrame: 1/TimeInterval(textures.count), resize: false, restore: false)), withKey: "animation")
        node.zPosition = 2
        node.addChild(collisionNode)
    }
    override func moveEnemy(direction: CGFloat) {
        if(!movCD && !dmgCD) {
            node.xScale = CGFloat(direction)
            let tempY = node.position.y > 233 ? -1.2 : 1.0
            node.removeAction(forKey: "moviment1")
            node.run(SKAction.move(to: CGPoint(x: node.position.x + (direction * speed), y: node.position.y + (tempY * speed)), duration: 1.5), withKey: "movement1")
            movCD = true
            let toggleMov = SKAction.run {
                self.movCD = false
            }
            node.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), toggleMov]), withKey: "movement")
        }
    }

    override func takeDamage(direction: CGFloat, damage: Int) -> Bool {
        if(!dmgCD) {
            dmgCD = true
            node.texture = SKTexture(imageNamed: "ghostDmg")
            node.removeAction(forKey: "movement")
            node.removeAction(forKey: "animation")
            node.removeAction(forKey: "movement1")
            node.run(SKAction.move(to: CGPoint(x: node.position.x + (direction * 3 * speed), y: node.position.y), duration: 1.5), withKey: "movement1")
            hp -= damage
            if(hp <= 0) {
                node.run(SKAction.fadeOut(withDuration: 1)) {
                    self.node.removeFromParent()
                }
                return true
            } else {
                node.run(SKAction.wait(forDuration: 1)) {
                    self.dmgCD = false
                    self.movCD = false
                    self.node.run(SKAction.repeatForever(SKAction.animate(with: self.textures, timePerFrame: 1/TimeInterval(self.textures.count), resize: false, restore: false)), withKey: "animation")
                }
                return false
            }
        } else {
            return false
        }
    }
}
