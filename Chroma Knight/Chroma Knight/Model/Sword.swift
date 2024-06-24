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
}
class Sword {
    var damage: Int
    var node: SKSpriteNode
    init(damage: Int, size: CGSize, type: SwordType) {
        let playerSize = CGSize(width: 809/15, height: 1024/15)
        self.damage = damage
        switch type {
        case .basic:
            self.node = SKSpriteNode(imageNamed: "basicSword")
            node.size = CGSize(width: 1024/15, height: 341/15)
            node.position = CGPoint(x: playerSize.width/2, y: -playerSize.height/4)
        case .dagger:
            self.node = SKSpriteNode(imageNamed: "daggers")
            node.size = CGSize(width: 1024/12, height: 136/12)
            node.position = CGPoint(x: 1, y: -playerSize.height/4)
        case .katana:
            self.node = SKSpriteNode(imageNamed: "katana")
        default:
            self.node = SKSpriteNode(imageNamed: "basicSword")
            node.size = CGSize(width: 1024/15, height: 341/15)
            node.position =  CGPoint(x: playerSize.width/2, y: -playerSize.height/4)
        }
        
        node.name = "sword"
    }
    
}
