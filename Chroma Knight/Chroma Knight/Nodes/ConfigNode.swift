//
//  ConfigNode.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 09/06/24.
//

import Foundation
import SpriteKit

class ConfigNode: SKNode {
    var optionsLabel: SKLabelNode
    
    var vibrationLabel: SKLabelNode
    var soundLabel: SKLabelNode
    
    var vibrationToggle: SKSpriteNode
    var soundToggle: SKSpriteNode
    
    var closeButton: SKSpriteNode
    
    var optionsBackground: SKSpriteNode
    
    init(size: CGSize) {
        optionsLabel = SKLabelNode(text: "Options")
        optionsLabel.fontColor = .black
        optionsLabel.fontSize = 32
        optionsLabel.fontName = appFont
        optionsLabel.position = CGPoint(x: size.width/2, y: size.height/1.4)
        optionsLabel.zPosition = 1
        
        vibrationLabel = SKLabelNode(text: "Haptics:")
        vibrationLabel.fontColor = .black
        vibrationLabel.fontSize = 16
        vibrationLabel.fontName = appFont
        vibrationLabel.position = CGPoint(x: size.width/3, y: size.height/2)
        vibrationLabel.zPosition = 1
        
        if(UserConfig.shared.vibration) {
            vibrationToggle = SKSpriteNode(imageNamed: "toggleOn")
        } else {
            vibrationToggle = SKSpriteNode(imageNamed: "toggleOff")
        }
        vibrationToggle.position = CGPoint(x: vibrationLabel.position.x, y: vibrationLabel.position.y - 30)
        vibrationToggle.zPosition = 1
        vibrationToggle.scale(to: CGSize(width: 80, height: 40))
        vibrationToggle.name = "vibrationToggle"
        
        soundLabel = SKLabelNode(text: "Sound:")
        soundLabel.fontColor = .black
        soundLabel.fontSize = 16
        soundLabel.fontName = appFont
        soundLabel.position = CGPoint(x: size.width/1.5, y: size.height/2)
        soundLabel.zPosition = 1
    
        if(UserConfig.shared.sound) {
            soundToggle = SKSpriteNode(imageNamed: "toggleOn")
        } else {
            soundToggle = SKSpriteNode(imageNamed: "toggleOff")
        }
        soundToggle.position = CGPoint(x: soundLabel.position.x, y: soundLabel.position.y - 30)
        soundToggle.zPosition = 1
        soundToggle.scale(to: CGSize(width: 80, height: 40))
        soundToggle.name = "soundToggle"
        
        optionsBackground = SKSpriteNode(imageNamed: "optionsBackground")
        optionsBackground.scale(to: size)
        optionsBackground.zPosition = 0
        optionsBackground.position = CGPoint(x: size.width/2, y: size.height/2)
        
        closeButton = SKSpriteNode(imageNamed: "closeButton")
        closeButton.scale(to: CGSize(width: 48, height: 48))
        closeButton.position = CGPoint(x: size.width - 80, y: size.height - 80)
        closeButton.zPosition = 1
        closeButton.name = "closeButton"
        
        super.init()
        addChild(vibrationLabel)
        addChild(soundLabel)
        addChild(optionsLabel)
        addChild(vibrationToggle)
        addChild(soundToggle)
        addChild(optionsBackground)
        addChild(closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
