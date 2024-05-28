//
//  MenuScene.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 28/05/24.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    var background: SKSpriteNode
    var titleLabel: SKLabelNode
    var playButton: SKSpriteNode
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "background")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        
        titleLabel = SKLabelNode(text: "Chroma Knight")
        titleLabel.fontSize = 64
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
        
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.scale(to: CGSize(width: 200, height: 100))
        playButton.position = CGPoint(x: size.width/2, y: size.height/2.5)
        playButton.zPosition = 0
        playButton.name = "playButton"
        
        super.init(size: size)
        addChild(background)
        addChild(playButton)
        addChild(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                switch name {
                case "playButton":
                    let gameScene = GameScene(size: self.size)
                    gameScene.scaleMode = self.scaleMode
                    self.view?.presentScene(gameScene)
                default:
                    break
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
