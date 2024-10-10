//
//  LevelOneTouches.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 26/07/24.
//

import Foundation
import SpriteKit

extension LevelOneScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                if(name.contains("Button") && !name.contains("right") && !name.contains("left") && !name.contains("action") && !name.contains("Attack") && !name.contains("Pressed")) {
                    vibrate(with: .light)
                    SoundManager.shared.playButtonSound()
                }
                if(name.contains("Toggle")) {
                    vibrate(with: .light)
                    SoundManager.shared.playToggleSound()
                }
                if let scene = self.view?.scene {
                    if(pauseNode.checkPauseNodePressed(scene: scene, touchedNode: touchedNode)) {
                        togglePause()
                    }
                }
                switch name {
                case "leftButton":
                    leftButtonPressed(touch: touch)
                case "rightButton":
                    rightButtonPressed(touch: touch)
                case "actionButton":
                    actionButtonPressed()
                case "jumpAttackButton":
                    jumpAttackButtonPressed()
                default:
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            // Check if the touch is already associated with a button
            if let button = activeTouches[touch] {
                // Check if the touch has moved outside the button
                if !button.contains(location) {
                    // Finger moved outside the selected button
                    deactivateButton(button: button)
                    activeTouches[touch] = nil
                    
                    // Check if there's another button at the new location
                    let newTouchedNode = atPoint(location)
                    if let name = newTouchedNode.name {
                        // Ensure the new button isn't already in activeTouches
                        if !activeTouches.values.contains(where: { $0.name == name }) {
                            switch name {
                            case "leftButton":
                                leftButtonPressed(touch: touch)
                            case "rightButton":
                                rightButtonPressed(touch: touch)
                            default:
                                break
                            }
                        }
                    }
                }
            } else {
                let node = atPoint(location)
                if let name = node.name {
                    // Ensure the button isn't already in activeTouches
                    if !activeTouches.values.contains(where: { $0.name == name }) {
                        switch name {
                        case "leftButton":
                            leftButtonPressed(touch: touch)
                        case "rightButton":
                            rightButtonPressed(touch: touch)
                        default:
                            break
                        }
                    }
                }
            }
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            verifyJumpButton(touch: touch)
            if let button = activeTouches[touch] {
                deactivateButton(button: button)
                activeTouches[touch] = nil
                player.animatePlayer()
                
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            verifyJumpButton(touch: touch)
            if let button = activeTouches[touch] {
                deactivateButton(button: button)
                activeTouches[touch] = nil
                player.animatePlayer()
            }
        }
    }
    
    
    func verifyJumpButton(touch: UITouch) {
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if let name = touchedNode.name {
            if(name == "jumpAttackButton") {
                pressingJumpAttack = false
                actionButton.texture = SKTexture(imageNamed: "jumpAttackButton")
            }
        }
        
    }
    
    func leftButtonPressed(touch: UITouch) {
        vibrate(with: .light)
        activeTouches[touch] = leftButton
        animateButton(button: leftButton)
        player.animateWalk()
    }
    
    func rightButtonPressed(touch: UITouch) {
        vibrate(with: .light)
        activeTouches[touch] = rightButton
        animateButton(button: rightButton)
        player.animateWalk()
    }
    
    func actionButtonPressed() {
        animateButton(button: actionButton)
        self.run(waitForAnimation) {
            deactivateButton(button: self.actionButton)
        }
        player.playerJump()
        actionButton.name = "jumpAttackButton"
        actionButton.texture = SKTexture(imageNamed: "jumpAttackButton")
    }
    func jumpAttackButtonPressed() {
        pressingJumpAttack = true
        player.jumpAttack()
        actionButton.texture = SKTexture(imageNamed: "jumpAttackButtonPressed")
    }
}
