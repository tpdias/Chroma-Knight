//
//  Merchant.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 31/07/24.
//

import Foundation
import SpriteKit

class Merchant {
    var node: SKSpriteNode
    var items: [Sword]
    var prices: [Int]
    init(size: CGSize, diff: Int) {
        self.node = SKSpriteNode(imageNamed: "merchant")
        self.items = [Sword(damage: 2, size: size, type: .void), Sword(damage: 1, size: size, type: .katana), Sword(damage: 1, size: size, type: .dagger)]
        node.size = CGSize(width: size.width/7, height: size.width/7)
        node.position = CGPoint(x: arc4random_uniform(100) < 50 ? size.width - node.size.width * 1.2 : node.size.width * 1.2, y: (size.height / 2 - size.height / 3.4) + node.size.height - node.size.height/2.5)
        self.prices = [200, 150, 100]
        node.zPosition = 1
    }
}
