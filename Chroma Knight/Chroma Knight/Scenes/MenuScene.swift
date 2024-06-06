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
    
    var playLabel: SKLabelNode
    var playButton: SKSpriteNode
    
    var optionsButton: SKSpriteNode
    var soundButton: SKSpriteNode
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "menuBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        
        titleLabel = SKLabelNode(text: "Chroma Knight")
        titleLabel.fontSize = 48
        titleLabel.fontName = "Retro Gaming"
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.5)
               
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.scale(to: CGSize(width: 200, height: 100))
        playButton.position = CGPoint(x: size.width/2, y: size.height/2.5)
        playButton.zPosition = 0
        playButton.name = "playButton"
                
        playLabel = SKLabelNode(text: "Start Game")
        playLabel.fontColor = .black
        playLabel.fontSize = 24
        playLabel.fontName = "Retro Gaming"
        playLabel.position = playButton.position
        playLabel.name = "playButton"
        
        optionsButton = SKSpriteNode(imageNamed: "optionsButton")
        optionsButton.scale(to: CGSize(width: 50, height: 50))
        optionsButton.position = CGPoint(x: size.width - 75, y: size.height - 50)
        optionsButton.zPosition = 0
        optionsButton.name = "optionsButton"
        
        soundButton = SKSpriteNode(imageNamed: "soundButton")
        soundButton.scale(to: CGSize(width: 50, height: 50))
        soundButton.position = CGPoint(x: 75, y: size.height - 50)
        soundButton.zPosition = 0
        soundButton.name = "soundButton"
        
        super.init(size: size)
        addChild(soundButton)
        addChild(background)
        addChild(playButton)
        addChild(optionsButton)
        addChild(titleLabel)
        addChild(playLabel)
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
                    animateButton(button: playButton)
                    playLabel.position.y -= 10
                    transitionToNextScene(scene: gameScene)
                case "optionsButton":
                    let optionsScene = OptionsScene(size: self.size)
                    optionsScene.scaleMode = self.scaleMode
                    animateButton(button: optionsButton)
                    transitionToNextScene(scene: optionsScene)
                case "soundButton":
                    UserConfig.shared.changeSound()
                    animateSoundButton(button: soundButton, isOn: UserConfig.shared.sound)
                default:
                    break
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func transitionToNextScene(scene: SKScene) {
        self.run(waitForAnimation) {
            self.view?.presentScene(scene)
        }
    }
}
