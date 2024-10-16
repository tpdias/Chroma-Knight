//
//  Sword.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 21/06/24.
//

import Foundation
import SpriteKit

enum SwordType {
    case basic
    case katana
    case dagger
    case void
}
class Sword {
    var damage: Int
    var node: SKSpriteNode
    var initialPos: CGPoint
    var type: SwordType
    init(damage: Int, size: CGSize, type: SwordType) {
        let playerSize = CGSize(width: 809/15, height: 1024/15)
        self.damage = damage
        switch type {
        case .basic:
            self.node = SKSpriteNode(imageNamed: "basicSword")
            node.size = CGSize(width: 1024/17, height: 341/17)
           // node.position = CGPoint(x: playerSize.width/2, y: -playerSize.height/4)
            self.type = .basic
        case .dagger:
            self.node = SKSpriteNode(imageNamed: "daggers")
            node.size = CGSize(width: 1024/20, height: 341/20)
            self.type = .dagger
        case .katana:
            self.node = SKSpriteNode(imageNamed: "katana")
            node.size = CGSize(width: 1024/10, height: 113/10)
            self.type = .katana
        case .void:
            self.node = SKSpriteNode(imageNamed: "voidSword")
            node.size = CGSize(width: 1024/13, height: 256/12)
            self.type = .void

        }
        node.position = CGPoint(x: 0, y: -playerSize.height/2.5)
        if type == .dagger {
            node.position.x += 10
        }
        initialPos = node.position

        node.name = "sword"
        node.anchorPoint = .zero
    }
    
    func animateSwordWalking(duration: CGFloat) {
        node.removeAllActions()
        node.position = initialPos
        let wait = SKAction.wait(forDuration: duration)
        let moveDown = SKAction.moveBy(x: 3, y: -2, duration: 0)
        let moveRight = SKAction.moveBy(x: -3, y: 0, duration: 0)
        let moveBack = SKAction.moveBy(x: 0, y: 2, duration: 0)
        let sequence = SKAction.sequence([moveDown, wait, moveRight, wait, moveBack, wait])
        node.run(SKAction.repeatForever(sequence))
    }
    func animateSwordStd(duration: CGFloat) {
        node.position = initialPos
        node.removeAllActions()
        let wait = SKAction.wait(forDuration: duration)
        let moveDown = SKAction.moveBy(x: 0, y: -2, duration: 0)
        let moveBack = SKAction.moveBy(x: 0, y: 2, duration: 0)
        let sequence = SKAction.sequence([moveDown, wait, moveBack, wait])
        node.run(SKAction.repeatForever(sequence))
    }
    func jumpAttack() {
        node.zRotation = 0
        
        node.removeAction(forKey: "rotation")
        
        node.position = initialPos
        node.position.y += 15
        let rotationAction = SKAction.rotate(byAngle: -(.pi/2), duration: 0.2)
        switch type {
        case .katana:
            node.run(SKAction.rotate(byAngle: .pi*(-2.25), duration: 0.5), withKey: "rotation")
            //node.run(SKAction.sequence([SKAction.rotate(byAngle: .pi/2, duration: 0.2),SKAction.rotate(byAngle: -.pi*2, duration: 0.5)]))
        default:
            node.run(rotationAction)
        }
        

    }
    func collideWithFloor() {
        node.zRotation = 0
        node.position = initialPos
    }

    func jumpAttackLeft() {
        node.zRotation = 0
        let rotationAction = SKAction.rotate(byAngle: (.pi/2), duration: 0.2)
        node.run(rotationAction)
        node.run(SKAction.move(by: CGVector(dx: 0, dy: 15), duration: 0.2))
    }
}
