import Foundation
import SpriteKit

class LevelOneScene: SKScene, SKPhysicsContactDelegate {
    // Backgrounds
    var controllerBackground: SKSpriteNode
    var background: SKSpriteNode
    // Controller
    var leftButton: SKSpriteNode
    var rightButton: SKSpriteNode
    var actionButton: SKSpriteNode
    
    var activeTouches: [UITouch: SKSpriteNode] = [:] // Dictionary to track touches and their corresponding buttons
    
    //Player
    var player: Player
    
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
        pauseNode.zPosition = 2
        
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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {}
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactA = contact.bodyA.categoryBitMask
        let contactB = contact.bodyB.categoryBitMask
        if(contactA == PhysicsCategory.player && contactB == PhysicsCategory.ground) || (contactA == PhysicsCategory.ground && contactB == PhysicsCategory.player) {
            if player.isJumping {
                player.isJumping = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        calculatePlayerMoviment()
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
                    actionButtonPressed(touch: touch)
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
            if let button = activeTouches[touch] {
                deactivateButton(button: button)
                activeTouches[touch] = nil
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let button = activeTouches[touch] {
                deactivateButton(button: button)
                activeTouches[touch] = nil
            }
        }
    }
    
    func leftButtonPressed(touch: UITouch) {
        vibrate(with: .light)
        activeTouches[touch] = leftButton
        animateButton(button: leftButton)
    }
    
    func rightButtonPressed(touch: UITouch) {
        vibrate(with: .light)
        activeTouches[touch] = rightButton
        animateButton(button: rightButton)
    }
    
    func actionButtonPressed(touch: UITouch) {
     //   activeTouches[touch] = actionButton
        animateButton(button: actionButton)
        self.run(waitForAnimation) {
            deactivateButton(button: self.actionButton)
        }
        player.playerJump()
    }
    
    func calculatePlayerMoviment() {
        if(activeTouches.values.contains(leftButton)) {
            player.movePlayer(distance: -player.movementSpeed)
        }
        if(activeTouches.values.contains(rightButton)) {
            player.movePlayer(distance: player.movementSpeed)
        }
    }
    

}


struct PhysicsCategory  {
    static let player: UInt32 = 0x1 << 0
    static let ground: UInt32 = 0x1 << 1
}
