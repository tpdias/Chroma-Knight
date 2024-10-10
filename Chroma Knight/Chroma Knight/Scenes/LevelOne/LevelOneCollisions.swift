//
//  LevelOneCollisions.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 26/07/24.
//

import Foundation
import SpriteKit

extension LevelOneScene {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask
        if(contactA == PhysicsCategory.player && contactB == PhysicsCategory.ground) || (contactA == PhysicsCategory.ground && contactB == PhysicsCategory.player) {
            collideWithFloor()
        }
        
        collideWithSlime(contactA: contactA, contactB: contactB, contact: contact)
                
        if(contactA == PhysicsCategory.fruits && contactB == PhysicsCategory.player || contactB == PhysicsCategory.fruits && contactA == PhysicsCategory.player) {
            
            if(contactA == PhysicsCategory.fruits) {
                if(addHp(hp: dificulty)) {
                    contact.bodyA.node?.removeFromParent()
                }
            } else {
                if(addHp(hp: dificulty)) {
                    contact.bodyB.node?.removeFromParent()
                }
            }
        }
        if(contactA == PhysicsCategory.coins && contactB == PhysicsCategory.player || contactB == PhysicsCategory.coins && contactA == PhysicsCategory.player) {
            increaseScore()
            if(contactA == PhysicsCategory.coins) {
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeFromParent()
            }
        }
        
        
        if(contactA == PhysicsCategory.player && contactB == PhysicsCategory.leftWall || contactB == PhysicsCategory.player && contactA == PhysicsCategory.leftWall ) {
            player.node.physicsBody?.velocity.dx = 0
        }
        
        if(contactA == PhysicsCategory.player && contactB == PhysicsCategory.rightWall || contactB == PhysicsCategory.player && contactA == PhysicsCategory.rightWall ) {
            player.node.physicsBody?.velocity.dx = 0
        }
    }
    
    func findSlime(body: SKNode?) -> Slime? {
        for slime in slimes {
            if slime.node == body?.physicsBody?.node {
                return slime
            }
        }
        return nil
    }
    
    func collideWithFloor() {
        increaseCombo()
        if player.isJumping {
            actionButton.name = "actionButton"
            actionButton.texture = SKTexture(imageNamed: "actionButton")
            player.collideWithFloor()
            if(activeTouches.values.contains(leftButton) || activeTouches.values.contains(rightButton)) {
                player.animateWalk()
            } else {
                player.animatePlayer()
            }
        }
    }
    
    func collideWithSlime(contactA: UInt32, contactB: UInt32, contact: SKPhysicsContact) {
        if((contactA == PhysicsCategory.player && contactB == PhysicsCategory.slime) || (contactA == PhysicsCategory.slime && contactB == PhysicsCategory.player)) {
            guard let slime = findSlime(body: (contactA == PhysicsCategory.slime) ? contact.bodyA.node : contact.bodyB.node) else { return }
            if slime.hp <= 0 { return }
            if slime.dmgCD { return }
            if(contact.bodyA.node?.name == "player") {
                let direction: CGFloat = (contact.bodyB.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1
                if(!player.damageCD) {
                    loseHp(dmg: slime.damage)
                }
                player.takeDamage(direction: direction, damage: slime.damage)
                
                slime.impulse(xForce: player.movementSpeed * -direction)
            } else {
                let direction: CGFloat = (contact.bodyA.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1
                if(!player.damageCD) {
                    loseHp(dmg: slime.damage)
                }
                player.takeDamage(direction: (contact.bodyA.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1, damage: 1)
                slime.impulse(xForce: player.movementSpeed * -direction)
            }
            
            if(checkGameOver()) {
                gameOver()
            }
        }
    }
    func checkSwordCollision(sword: SKSpriteNode) {
        for (i, slime) in slimes.enumerated() {
            if(sword.intersects(slime.node)) {
                if(player.isJumpAttacking) {
                    player.impulsePlayer(vector: CGVector(dx: 0, dy: pressingJumpAttack ? player.jumpForce/1.2 : player.jumpForce/2))
                    if(!slime.dmgCD){
                        if player.sword.type == .katana {
                            player.isJumpAttacking = false
                            player.jumpAttack()
                        }
                        player.incCombo()
                        increaseCombo()
                    }
                }
                if(slime.takeDamage(direction: player.node.position.x > slime.node.position.x ? -1 : 1, damage: player.getDamage())) {
                    killEnemy(position: slime.node.position)
                    slimes.remove(at: i)
                    break
                }
            }
        }
        for (i, ghost) in ghosts.enumerated() {
            if(sword.intersects(ghost.collisionNode)) {
                var damage = player.getDamage()
                if(player.isJumpAttacking) {
                    if(!ghost.dmgCD){
                        
                        player.incCombo()
                        damage = ghost.hp + 1
                    }
                }
                if(ghost.takeDamage(direction: player.node.position.x > ghost.node.position.x ? -1 : 1, damage: damage)) {
                    killEnemy(position: ghost.node.position)
                    ghosts.remove(at: i)
                    break
                }
            }
        }
    }
    
    func killEnemy(position: CGPoint) {
        if arc4random_uniform(100) < 5 {
            let newFruit = Fruit(size: size)
            addChild(newFruit.node)
            newFruit.node.zPosition = 2
            newFruit.node.position = position
            newFruit.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 4))
        }
        let newCoin = Coin(size: size)
        addChild(newCoin.node)
        newCoin.node.zPosition = 2
        newCoin.node.position = position
        newCoin.node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 5))
    }
    
    func checkMerchantCollision() {
        guard let merchant = self.merchant else { 
            return
        }
        
        if(player.node.intersects(merchant.node)) {
            openShop()
        }
    }
    func checkGhostCollision() {
        ghosts.forEach { ghost in
            if ghost.collisionNode.intersects(player.node) {
               collideWithGhost(ghost: ghost)
            }
        }
    }
    
    func checkSlimeKingCollision(slimeKing: SlimeKing) {
        if slimeKing.isFistAttacking {
            if slimeKing.fist.intersects(player.node) {
                let direction = slimeKing.fist.position.x > player.node.position.x ? 0 : 1
                if(!slimeKing.fistDmgCD) {
                    if(!player.damageCD) {
                        loseHp(dmg: 1)
                    }
                    player.takeDamage(direction: CGFloat(direction), damage: 1)
                    slimeKing.fistDmgCD = true
                }
            }
        }
        
        if player.sword.node.intersects(slimeKing.node) && !slimeKing.damageCD {
            slimeKing.takeDamage()            
        }
        
        if(checkGameOver()) {
            gameOver()
        }
    }
    
    func collideWithGhost(ghost: Ghost) {
        if ghost.hp <= 0 { return }
        if ghost.dmgCD { return }
        let direction: CGFloat = (ghost.node.position.x > player.node.position.x) ? -1  : 1
        if(!player.damageCD) {
            loseHp(dmg: ghost.damage)
        }
        player.takeDamage(direction: direction, damage: ghost.damage)
        
        //ghost.impulse(xForce: player.movementSpeed * -direction)
        ghost.moveEnemy(direction: -direction * 3)
        if(checkGameOver()) {
            gameOver()
        }
    }
    
}

struct PhysicsCategory {
    static let none: UInt32 = 0
    static let player: UInt32 = 1 << 0
    static let ground: UInt32 = 1 << 1
    static let slime: UInt32 = 1 << 2
   // static let ghost: UInt32 = 1 << 3
    static let rightWall: UInt32 = 1 << 4
    static let leftWall: UInt32 = 1 << 5
    static let fruits: UInt32 = 1 << 6
    static let coins: UInt32 = 1 << 7
    static let slimeKing: UInt32 = 1 << 8
}

