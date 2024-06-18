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
    var movimentSpeed: CGFloat
    init(size: CGSize) {
        self.movimentSpeed = 2.0
        self.node = SKSpriteNode(imageNamed: "player0")
        node.size = CGSize(width: 809/15, height: 1024/15)
        node.position = CGPoint(x: size.width/2, y: (size.height / 2 - size.height / 3.4) + node.size.height)
        node.zPosition = 1
        node.name = "player"
    }
    
    func movePlayer(distance: CGFloat) {
        node.position.x += distance
        if(distance <= 0) {
            node.xScale = -1.0
        } else {
            node.xScale = 1.0
        }
    }
}
