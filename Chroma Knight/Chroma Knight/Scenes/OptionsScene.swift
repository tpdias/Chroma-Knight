//
//  OptionsScene.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 29/05/24.
//

import Foundation
import SpriteKit

class OptionsScene: SKScene {
    var background: SKSpriteNode
    var titleLabel: SKLabelNode
    var backButton: SKSpriteNode
    var soundToggle: SKSpriteNode
    var vibrationToggle: SKSpriteNode
    var soundLabel: SKLabelNode
    var soundShadow: SKLabelNode
    var vibrationLabel: SKLabelNode
    var vibrationShadow: SKLabelNode
    var titleShadow: SKLabelNode
    
    override init(size: CGSize) {
        background = SKSpriteNode(imageNamed: "menuBackground")
        background.scale(to: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.name = "background"
        background.alpha = 0.7
        
        titleLabel = SKLabelNode(text: "Options")
        titleLabel.fontSize = 48
        titleLabel.fontColor = .main
        titleLabel.fontName = "Retro Gaming"
        titleLabel.position = CGPoint(x: size.width/2, y: size.height/1.3)
        
        titleShadow = SKLabelNode(text: "Options")
        titleShadow.fontSize = 48
        titleShadow.fontName = "Retro Gaming"
        titleShadow.fontColor = .black
        titleShadow.position = CGPoint(x: titleLabel.position.x + 3, y: titleLabel.position.y - 5)
        
        backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.scale(to: CGSize(width: 50, height: 50))
        backButton.position = CGPoint(x: 75, y: size.height - 50)
        backButton.zPosition = 0
        backButton.name = "backButton"
        
        soundLabel = SKLabelNode(text: "Sound")
        soundLabel.fontColor = .main
        soundLabel.fontSize = 24
        soundLabel.fontName = "Retro Gaming"
        soundLabel.position = CGPoint(x: titleLabel.position.x, y: titleLabel.position.y - 100)
        soundLabel.zPosition = 0
        
        soundShadow = SKLabelNode(text: "Sound")
        soundShadow.fontSize = 24
        soundShadow.fontName = "Retro Gaming"
        soundShadow.fontColor = .black
        soundShadow.position = CGPoint(x: soundLabel.position.x + 3, y: soundLabel.position.y - 2)
        
        soundToggle = SKSpriteNode(imageNamed: "toggleOn")
        if(!SoundManager.shared.soundEnabled) {
            soundToggle.texture = SKTexture(imageNamed: "toggleOff")
        }
        soundToggle.scale(to: CGSize(width: 80, height: 40))
        soundToggle.position = CGPoint(x: soundLabel.position.x, y: soundLabel.position.y - 30)
        soundToggle.zPosition = 0
        soundToggle.name = "soundToggle"
        
        vibrationLabel = SKLabelNode(text: "Vibration")
        vibrationLabel.fontColor = .main
        vibrationLabel.fontSize = 24
        vibrationLabel.zPosition = 0
        vibrationLabel.fontName = "Retro Gaming"
        vibrationLabel.position = CGPoint(x: soundToggle.position.x, y: soundToggle.position.y - 50)
        
        
        vibrationShadow = SKLabelNode(text: "Vibration")
        vibrationShadow.fontSize = 24
        vibrationShadow.fontName = "Retro Gaming"
        vibrationShadow.fontColor = .black
        vibrationShadow.position = CGPoint(x: vibrationLabel.position.x + 3, y: vibrationLabel.position.y - 2)
        
        vibrationToggle = SKSpriteNode(imageNamed: "toggleOn")
        if(!UserConfig.shared.vibration) {
            vibrationToggle.texture = SKTexture(imageNamed: "toggleOff")
        }
        vibrationToggle.scale(to: CGSize(width: 80, height: 40))
        vibrationToggle.position = CGPoint(x: vibrationLabel.position.x, y: vibrationLabel.position.y - 30)
        vibrationToggle.zPosition = 0
        vibrationToggle.name = "vibrationToggle"
        
        super.init(size: size)
        addChild(titleShadow)
        addChild(soundShadow)
        addChild(vibrationShadow)
        addChild(background)
        addChild(backButton)
        addChild(vibrationLabel)
        addChild(soundLabel)
        addChild(soundToggle)
        addChild(vibrationToggle)
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
                if(name.contains("Button") ) {
                    vibrate(with: .light)
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle")) {
                    vibrate(with: .light)
                    SoundManager.shared.playToggleSound()
                }
                switch name {
                case "backButton":
                    let menuScene = MenuScene(size: self.size)
                    menuScene.scaleMode = self.scaleMode
                    animateButton(button: backButton)
                    transitionToNextScene(scene: menuScene)
                case "soundToggle":
                    SoundManager.soundTrack.changeSound()
                    animateToggle(toggle: soundToggle, isOn: SoundManager.shared.soundEnabled)
                    if(SoundManager.soundTrack.soundEnabled) {
                        SoundManager.soundTrack.playSoundtrack()
                    }
                    break
                case "vibrationToggle":
                    UserConfig.shared.changeVibration()
                    animateToggle(toggle: vibrationToggle, isOn: UserConfig.shared.vibration)
                    break
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
