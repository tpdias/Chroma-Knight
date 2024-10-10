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
    var titleShadow: SKLabelNode
    
    var playLabel: SKLabelNode
    var playButton: SKSpriteNode
    
    var optionsButton: SKSpriteNode
    var soundButton: SKSpriteNode
    
    var highscoreLabel: SKLabelNode
    var highscore = UserDefaults.standard.integer(forKey: "highscore")
    var lastScoreLabel: SKLabelNode
    var lastScore = UserDefaults.standard.integer(forKey: "lastscore")
    
    override init(size: CGSize) {
    
       print(size)
        var realSize = size
        if(realSize.width/realSize.height <= 1) {
            realSize = CGSize(width: 852, height: 393)
        }
        background = SKSpriteNode(imageNamed: "menuBackground")
        background.scale(to: realSize)
        background.position = CGPoint(x: realSize.width/2, y: realSize.height/2)
        background.zPosition = -1
        background.alpha = 0.7
        background.name = "background"
        print(realSize)
        
        titleLabel = SKLabelNode(text: "Chroma Knight")
        titleLabel.fontSize = 48
        titleLabel.fontName = "Retro Gaming"
        titleLabel.fontColor = .main
        titleLabel.position = CGPoint(x: realSize.width/2, y: realSize.height/1.5)
        
        titleShadow = SKLabelNode(text: "Chroma Knight")
        titleShadow.fontSize = 48
        titleShadow.fontName = "Retro Gaming"
        titleShadow.fontColor = .black
        titleShadow.position = CGPoint(x: titleLabel.position.x + 3, y: titleLabel.position.y - 5)
               
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.scale(to: CGSize(width: 200, height: 100))
        playButton.position = CGPoint(x: realSize.width/2, y: realSize.height/2.5)
        playButton.zPosition = 0
        playButton.name = "playButton"
                
        playLabel = SKLabelNode(text: "Start Game")
        playLabel.fontColor = .black
        playLabel.fontSize = 24
        playLabel.fontName = "Retro Gaming"
        playLabel.position = CGPoint(x: playButton.position.x, y: playButton.position.y + 5)
        playLabel.name = "playButton"
        
        optionsButton = SKSpriteNode(imageNamed: "optionsButton")
        optionsButton.scale(to: CGSize(width: 50, height: 50))
        optionsButton.position = CGPoint(x: realSize.width - 75, y: realSize.height - 50)
        optionsButton.zPosition = 0
        optionsButton.name = "optionsButton"
        
        soundButton = SKSpriteNode(imageNamed: "soundButton")
        if(!SoundManager.shared.soundEnabled) {
            soundButton.texture = SKTexture(imageNamed: "soundButtonOff")
        }
        soundButton.scale(to: CGSize(width: 50, height: 50))
        soundButton.position = CGPoint(x: 75, y: realSize.height - 50)
        soundButton.zPosition = 0
        soundButton.name = "soundButton"
        
        highscoreLabel = SKLabelNode(text: "Highscore: \(highscore)")
        highscoreLabel.fontColor = .white
        highscoreLabel.fontName = appFont
        highscoreLabel.fontSize = 24
        highscoreLabel.position = CGPoint(x: 50, y: 25)
        highscoreLabel.zPosition = 1
        highscoreLabel.horizontalAlignmentMode = .left
        
        lastScoreLabel = SKLabelNode(text: "Last Score: \(lastScore)")
        lastScoreLabel.fontColor = .white
        lastScoreLabel.fontName = appFont
        lastScoreLabel.fontSize = 24
        lastScoreLabel.position = CGPoint(x: highscoreLabel.position.x, y: highscoreLabel.position.y + 30)
        lastScoreLabel.zPosition = 1
        lastScoreLabel.horizontalAlignmentMode = .left
        super.init(size: realSize)
        SoundManager.shared.stopSounds()
        SoundManager.shared.playSoundtrack()
        addChild(soundButton)
        addChild(background)
        addChild(playButton)
        addChild(optionsButton)
        addChild(titleShadow)
        addChild(titleLabel)
        addChild(playLabel)
        addChild(highscoreLabel)
        addChild(lastScoreLabel)
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
                if(name.contains("Button")) {
                    vibrate(with: .light)
                }
                
                switch name {
                case "playButton":
                    let levelOneScene = LevelOneScene(size: self.size)
                    levelOneScene.scaleMode = self.scaleMode
                    animateButton(button: playButton)
                    playLabel.position.y -= 10
                    transitionToNextScene(scene: levelOneScene)
                case "optionsButton":
                    let optionsScene = OptionsScene(size: self.size)
                    optionsScene.scaleMode = self.scaleMode
                    animateButton(button: optionsButton)
                    transitionToNextScene(scene: optionsScene)
                case "soundButton":
                    SoundManager.shared.changeSound()
                    animateSoundButton(button: soundButton, isOn: SoundManager.shared.soundEnabled)
                    SoundManager.shared.playSoundtrack()
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
