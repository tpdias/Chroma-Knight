//
//  LevelOneScene.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 09/06/24.
//

import Foundation
import SpriteKit

class LevelOneScene: SKScene {
    var controllerBackground: SKSpriteNode
    var background: SKSpriteNode
    var pauseNode: PauseNode
    
    override init(size: CGSize) {
        
        controllerBackground = SKSpriteNode(imageNamed: "controllerBackground")
        controllerBackground.scale(to: CGSize(width: size.width, height: size.height/3))
        controllerBackground.position = CGPoint(x: size.width/2, y: size.height/2 - size.height/3)
        controllerBackground.zPosition = -1
        
        background = SKSpriteNode(imageNamed: "levelOneBackground")
        background.scale(to: CGSize(width: size.width, height: size.height/1.2))
        background.position = CGPoint(x: size.width/2, y: size.height/2 + size.height/5)
        background.zPosition = -1
        
        pauseNode = PauseNode(size: size)
        
        super.init(size: size)
        backgroundColor = .black

        addChild(pauseNode)
        addChild(controllerBackground)
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                if let scene = self.view?.scene {
                    pauseNode.checkPauseNodePressed(scene: scene, touchedNode: touchedNode)
                }
                switch name {
                default:
                    break
                }
            }
        }
    }
    
}
