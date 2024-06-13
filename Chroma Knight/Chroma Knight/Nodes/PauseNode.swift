//
//  PauseNode.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 09/06/24.
//

import Foundation
import SpriteKit

class PauseNode: SKNode {
    var pauseButton: SKSpriteNode
    var resumeButton: SKSpriteNode
    var homeButton: SKSpriteNode
    var configButton: SKSpriteNode
    var configNode: ConfigNode
    
    init(size: CGSize) {
        
        pauseButton = SKSpriteNode(imageNamed: "pauseButton")
        pauseButton.scale(to: CGSize(width: 48, height: 48))
        pauseButton.position = CGPoint(x: size.width - 70, y: size.height - 70)
        pauseButton.name = "pauseButton"
        pauseButton.zPosition = 1
        
        resumeButton = SKSpriteNode(imageNamed: "resumeButton")
        resumeButton.scale(to: CGSize(width: 120, height: 120))
        resumeButton.position = CGPoint(x: size.width/2, y: size.height/2)
        resumeButton.zPosition = 1
        resumeButton.name = "resumeButton"
        
        homeButton = SKSpriteNode(imageNamed: "homeButton")
        homeButton.scale(to: CGSize(width: 96, height: 96))
        homeButton.position = CGPoint(x: size.width / 2 - 200, y: size.height/2 - 48)
        homeButton.zPosition = 1
        homeButton.name = "homeButton"
        
        configButton = SKSpriteNode(imageNamed: "optionsButton")
        configButton.scale(to: CGSize(width: 96, height: 96))
        configButton.position = CGPoint(x: size.width/2 + 200, y: size.height/2 - 48)
        configButton.zPosition = 1
        configButton.name = "optionsButton"
        
        configNode = ConfigNode(size: size)
        configNode.zPosition = 2
        super.init()
        self.addChild(pauseButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkPauseNodePressed(scene: SKScene, touchedNode: SKNode) {
        switch(touchedNode.name) {
        case "pauseButton" :
            animateButton(button: pauseButton)
            pauseButtonPressed()
            break
        case "resumeButton":
            animateButton(button: resumeButton)
            pauseButtonPressed()
            break
        case "homeButton":
            homeButtonPressed(scene: scene)
        case "optionsButton":
            optionsButtonPressed()
        case "closeButton":
            animateButton(button: configNode.closeButton)
            self.closeButtonPressed()
        case "vibrationToggle":
            UserConfig.shared.changeVibration()
            animateToggle(toggle: configNode.vibrationToggle, isOn: UserConfig.shared.vibration)
        case "soundToggle":
            UserConfig.shared.changeSound()
            animateToggle(toggle: configNode.soundToggle, isOn: UserConfig.shared.sound)
        default:
            break
        }
    }
    func closeButtonPressed() {
        self.run(waitForAnimation) {
            self.configNode.closeButton.texture = SKTexture(imageNamed: "closeButton")
            self.configNode.removeFromParent()
        }
    }
    func pauseButtonPressed() {
        pauseButton.run(waitForAnimation) {
            UserConfig.shared.changePause()
            self.pauseButton.texture = SKTexture(imageNamed: "pauseButton")
            self.resumeButton.texture = SKTexture(imageNamed: "resumeButton")
            if(UserConfig.shared.userPause) {
                self.addChild(self.resumeButton)
                self.addChild(self.configButton)
                self.addChild(self.homeButton)
            } else {
                self.resumeButton.removeFromParent()
                self.configButton.removeFromParent()
                self.homeButton.removeFromParent()
            }
        }
    }
   
    func homeButtonPressed(scene: SKScene) {
        animateButton(button: homeButton)
        let sequence = SKAction.sequence([waitForAnimation, fadeOut])
        scene.run(sequence) {
            UserConfig.shared.changePause()
            let menuScene = MenuScene(size: scene.size)
            menuScene.scaleMode = scene.scaleMode
            scene.view?.presentScene(menuScene)
        }
    }
    
    func optionsButtonPressed() {
        animateButton(button: configButton)
        configButton.run(waitForAnimation) {
            self.addChild(self.configNode)
            self.configButton.texture = SKTexture(imageNamed: "optionsButton")
        }
    }
    
}
