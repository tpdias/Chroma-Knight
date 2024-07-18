import Foundation
import SpriteKit
import UIKit

class LevelOneScene: SKScene, SKPhysicsContactDelegate {
    // Backgrounds
    var controllerBackground: SKSpriteNode
    var background: SKSpriteNode
    // Controller
    var leftButton: SKSpriteNode
    var rightButton: SKSpriteNode
    var actionButton: SKSpriteNode
    
    var activeTouches: [UITouch: SKSpriteNode] = [:] // Dictionary to track touches and their corresponding buttons
    var pressingJumpAttack: Bool = false
    //Player
    var player: Player
    
    var slimes: [Slime] = []
    var ghosts: [Ghost] = []
    
    
    //ground
    var ground: SKSpriteNode
    
    // Pause
    var pauseNode: PauseNode
    
    override init(size: CGSize) {
        controllerBackground = SKSpriteNode(imageNamed: "controllerBackground")
        controllerBackground.scale(to: CGSize(width: size.width, height: size.height / 3))
        controllerBackground.position = CGPoint(x: size.width / 2, y: size.height / 2 - size.height / 2.7)
        controllerBackground.zPosition = -1
        
        background = SKSpriteNode(imageNamed: "levelOneBackground")
        background.scale(to: CGSize(width: size.width, height: size.height / 1.2))
        background.position = CGPoint(x: size.width / 2, y: size.height / 2 + size.height / 5)
        background.zPosition = -2
        
        pauseNode = PauseNode(size: size)
        pauseNode.zPosition = 3
        
        let buttonsX = size.width / 5
        let buttonsSize: CGFloat = 100
        let buttonsHeight = size.height / 3 - buttonsSize / 1.5
        leftButton = SKSpriteNode(imageNamed: "leftButton")
        leftButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        leftButton.position = CGPoint(x: buttonsX, y: buttonsHeight)
        leftButton.zPosition = 1
        leftButton.name = "leftButton"
        
        rightButton = SKSpriteNode(imageNamed: "rightButton")
        rightButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        rightButton.position = CGPoint(x: buttonsX + buttonsSize * 1.5, y: buttonsHeight)
        rightButton.zPosition = 1
        rightButton.name = "rightButton"
        
        actionButton = SKSpriteNode(imageNamed: "actionButton")
        actionButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        actionButton.position = CGPoint(x: size.width - buttonsX * 1.1, y: buttonsHeight)
        actionButton.zPosition = 1
        actionButton.name = "actionButton"
        
        
        player = Player(size: size, sword: Sword(damage: 1, size: size, type: .basic))
        
        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 10))
        ground.position = CGPoint(x: size.width/2, y: player.node.position.y - player.node.size.height/1.8)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.player
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
        super.init(size: size)

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        backgroundColor = .black
        addChild(ground)
        addChild(player.node)
        addChild(leftButton)
        addChild(rightButton)
        addChild(actionButton)
        addChild(pauseNode)
        addChild(controllerBackground)
        addChild(background)
        
        //new
        spawnEnemy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true
#if os(macOS)
        self.view?.window?.makeFirstResponder(self)
#endif
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask
        if(contactA == PhysicsCategory.player && contactB == PhysicsCategory.ground) || (contactA == PhysicsCategory.ground && contactB == PhysicsCategory.player) {
            collideWithFloor()
        }
        
        if((contactA == PhysicsCategory.player && contactB == PhysicsCategory.slime) || (contactA == PhysicsCategory.slime && contactB == PhysicsCategory.player)) {
            if(contact.bodyA.node?.name == "player") {
                let direction: CGFloat = (contact.bodyB.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1
                player.takeDamage(direction: direction, damage: 1)
                contact.bodyB.node?.physicsBody?.velocity = CGVector.zero
                contact.bodyB.node?.physicsBody?.applyImpulse(CGVector(dx: player.movementSpeed * -direction, dy: 25))
            } else {
                let direction: CGFloat = (contact.bodyA.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1
                player.takeDamage(direction: (contact.bodyA.node?.position.x ?? 0 > player.node.position.x) ? -1  : 1, damage: 1)
                contact.bodyA.node?.physicsBody?.velocity = CGVector.zero
                contact.bodyA.node?.physicsBody?.applyImpulse(CGVector(dx: player.movementSpeed * -direction, dy: 25))
            }
            
            if(checkGameOver()) {
                let scene = MenuScene(size: self.size)
                scene.scaleMode = self.scaleMode
                self.view?.presentScene(scene)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        calculatePlayerMovement()
        calculateEnemyMovement()
        checkSwordCollision()
    }
    
    func collideWithFloor() {
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
    func checkGameOver() -> Bool {
        if(player.hp <= 0) {
            return true
        }
        return false
    }
    
    func checkSwordCollision() {
        var i = 0
        for slime in slimes {
            if(player.sword.node.intersects(slime.node)) {
                if(player.isJumpAttacking) {
                    player.impulsePlayer(force: pressingJumpAttack ? player.jumpForce/1.2 : player.jumpForce/2)
                }
                if(slime.takeDamage(direction: player.node.position.x > slime.node.position.x ? -1 : 1)) {
                    slimes.remove(at: i)
                }
                i += 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if let name = touchedNode.name {
                if(name.contains("Button") || name.contains("Toggle")) {
                    vibrate(with: .light)
                }
                if let scene = self.view?.scene {
                    pauseNode.checkPauseNodePressed(scene: scene, touchedNode: touchedNode)
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
                if let button = activeTouches[touch] {
                    if !button.contains(location) {
                        // Finger moved outside the selected button
                        deactivateButton(button: button)
                        activeTouches[touch] = nil
                        
                        // Check if there's another button at the new location
                        let newTouchedNode = atPoint(location)
                        if let name = newTouchedNode.name {
                            switch name {
                            case "leftButton":
                                leftButtonPressed(touch: touch)
                            case "rightButton":
                                rightButtonPressed(touch: touch)
//                            case "actionButton":
//                                actionButtonPressed(touch: touch)
                            default:
                                break
                            }
                        }
                    }
                } else {
                    let node = atPoint(location)
                    if let name = node.name {
                        switch name {
                        case "leftButton":
                            leftButtonPressed(touch: touch)
                        case "rightButton":
                            rightButtonPressed(touch: touch)
//                        case "actionButton":
//                            actionButtonPressed(touch: touch)
                        default:
                            break
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
 
    func spawnEnemy() {
        let spawn = SKAction.run { [weak self] in
            let newSlime = Slime(hp: 3, damage: 1, speed: 8)
            let position = CGPoint(x: 0, y: (self?.ground.position.y ?? 0) + newSlime.node.size.height/2 * 1.2)
            newSlime.node.position = position
            self?.slimes.append(newSlime)
            self?.addChild(newSlime.node)
        }
        self.run(SKAction.repeatForever(SKAction.group([spawn, SKAction.wait(forDuration: 2)])))
    }
    
    func calculateEnemyMovement() {
        for enemy in slimes {
            enemy.moveEnemy(direction: player.node.position.x >= enemy.node.position.x ? 1 : -1)
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
   
    func calculatePlayerMovement() {
        if(activeTouches.values.contains(leftButton)) {
            player.movePlayer(direction: -1)
        }
        if(activeTouches.values.contains(rightButton)) {
            player.movePlayer(direction: 1)
            
        }
    }
 
}


struct PhysicsCategory  {
    static let none: UInt32 = 0
    static let player: UInt32 = 0b1
    static let ground: UInt32 = 0b10
    static let slime: UInt32 = 0b100
}
