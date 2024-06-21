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
        self.damage = damage
        switch type {
        case .basic:
            self.node = SKSpriteNode(imageNamed: "basicSword")
        default:
            self.node = SKSpriteNode(imageNamed: "basicSword")
        }
        node.size = CGSize(width: 1024/15, height: 341/15)
        node.name = "sword"
    }
    
}
