import Foundation
import SpriteKit
import UIKit
import GoogleMobileAds

class LevelOneScene: SKScene, SKPhysicsContactDelegate, GADFullScreenContentDelegate {
    
    //for ads
    private var interstitial: GADInterstitialAd?
    
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
    
    //boss
    var slimeKing: SlimeKing
    
    var merchant: Merchant?
    //ground
    var ground: SKSpriteNode
    
    // Pause
    var pauseNode: PauseNode
    
    var rightWall: SKSpriteNode
    var leftWall: SKSpriteNode
    
    var scoreNode: SKLabelNode
    var spawnNode: SKNode
    var pauseStatus: Bool = false
    var heartSprites: [SKSpriteNode] =  []
    
    var dificulty = 1
    var shopOpen = false
    
    var comboLabel: SKLabelNode
    
    
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
        pauseNode.zPosition = 5
        
        let buttonsX = 100.0
        let buttonsSize: CGFloat = 100
        let buttonsHeight = size.height / 3 - buttonsSize / 1.5
        leftButton = SKSpriteNode(imageNamed: "leftButton")
        leftButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        leftButton.position = CGPoint(x: buttonsX, y: buttonsHeight)
        leftButton.zPosition = 2
        leftButton.name = "leftButton"
        
        rightButton = SKSpriteNode(imageNamed: "rightButton")
        rightButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        rightButton.position = CGPoint(x: buttonsX + buttonsSize * 1.5, y: buttonsHeight)
        rightButton.zPosition = 2
        rightButton.name = "rightButton"
        
        actionButton = SKSpriteNode(imageNamed: "actionButton")
        actionButton.scale(to: CGSize(width: buttonsSize, height: buttonsSize))
        actionButton.position = CGPoint(x: size.width - buttonsX * 1.1, y: buttonsHeight)
        actionButton.zPosition = 2
        actionButton.name = "actionButton"
        
        
        player = Player(size: size, sword: Sword(damage: 1, size: size, type: .basic))
        ground = SKSpriteNode(color: .clear, size: CGSize(width: size.width * 2, height: 10))
        ground.position = CGPoint(x: size.width/2, y: player.node.position.y - player.node.size.height/1.8)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.player
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        rightWall = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        rightWall.position = CGPoint(x: size.width, y: size.height/2)
        rightWall.physicsBody = SKPhysicsBody(rectangleOf: rightWall.size)
        rightWall.physicsBody?.isDynamic = false
        rightWall.physicsBody?.isResting = true
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.rightWall
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.player
        rightWall.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        leftWall = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: size.height))
        leftWall.position = CGPoint(x: 0, y: size.height/2)
        leftWall.physicsBody = SKPhysicsBody(rectangleOf: leftWall.size)
        leftWall.physicsBody?.isDynamic = false
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.leftWall
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.player
        leftWall.physicsBody?.contactTestBitMask = PhysicsCategory.player
        
        //new
        scoreNode = SKLabelNode(text: "\(player.points)")
        scoreNode.position = CGPoint(x: 50, y: size.height - 50)
        scoreNode.fontColor = .white
        scoreNode.fontName = appFont
        scoreNode.zPosition = 1
        
        spawnNode = SKNode()
        
        comboLabel = SKLabelNode(text: "")
        comboLabel.position = CGPoint(x: size.width/2, y: size.height - 50)
        comboLabel.fontColor = .white
        comboLabel.fontName = appFont
        comboLabel.zPosition = 1
        
        slimeKing = SlimeKing(size: size)
        super.init(size: size)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = self
        
        backgroundColor = .black
        addChild(ground)
        addChild(leftWall)
        addChild(rightWall)
        addChild(scoreNode)
        addChild(player.node)
        addChild(leftButton)
        addChild(rightButton)
        addChild(actionButton)
        addChild(pauseNode)
        addChild(controllerBackground)
        addChild(background)
        addChild(spawnNode)
        addChild(comboLabel)
        
        //new
        spawnEnemy()
        initiateHp()
        
        let incDiff = SKAction.run {
            self.dificulty += 1
            if self.dificulty == 3 {
                let newMerchant = Merchant(size: size, diff: self.dificulty)
                self.merchant = newMerchant
                self.run(SKAction.wait(forDuration: 15)) {
                    if(!self.shopOpen) {
                        self.closeShop()
                    }
                }
                newMerchant.node.alpha = 0
                self.addChild(newMerchant.node)
                newMerchant.node.run(SKAction.fadeIn(withDuration: 0.5))
            }
            if self.dificulty == 4 {
                self.slimeKing.isAlive = true
                self.addChild(self.slimeKing.node)
                self.slimeKing.spawn()
            }
        }
        self.spawnNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 15), incDiff])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        let adUnitID = "ca-app-pub-1405347505060440/9572593172" // Coloque aqui o ID do seu bloco de anúncios
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        // Remove observers when the scene is no longer in the view hierarchy
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appDidEnterBackground() {
    }
    
    @objc func appWillEnterForeground() {
        for slime in slimes {
            slime.node.isPaused = pauseStatus
        }
        for ghost in ghosts {
            ghost.node.isPaused = pauseStatus
        }
        player.node.isPaused = pauseStatus
        spawnNode.isPaused = pauseStatus
    }
    
    override func update(_ currentTime: TimeInterval) {
        calculatePlayerMovement()
        calculateEnemyMovement()
        checkSwordCollision(sword: player.sword.node)
        if let swordNode = player.leftSword?.node {
            checkSwordCollision(sword: swordNode)
        }
        checkMerchantCollision()
        checkGhostCollision()
        
        if slimeKing.isAlive {
            checkSlimeKingCollision(slimeKing: slimeKing)
        }
    }
    
    func initiateHp() {
        for i in 0..<Int(player.hp) {
            let hpHeart = SKSpriteNode(imageNamed: "heart")
            hpHeart.size = CGSize(width: 30, height: 30)
            hpHeart.position = CGPoint(x: 50 * (i + 1) + 5*i, y: Int(size.height) - 80)
            hpHeart.zPosition = 3
            addChild(hpHeart)
            heartSprites.append(hpHeart)
        }
    }
    
    func loseHp(dmg: Int) {
        vibrate(with: .heavy)
        for _ in 0..<dmg {
            if(heartSprites.count >= 1) {
                heartSprites[heartSprites.count - 1].removeFromParent()
                heartSprites.removeLast()
            }
        }
    }
    func addHp(hp: Int) -> Bool{
        if(player.hp < player.maxHP) {
            var healingAmount = hp
            if (hp + player.hp > player.maxHP) {
                healingAmount = player.maxHP - player.hp
            }
            player.incHp(hp: healingAmount)
            for i in heartSprites.count..<player.hp {
                let hpHeart = SKSpriteNode(imageNamed: "heart")
                hpHeart.size = CGSize(width: 30, height: 30)
                hpHeart.position = CGPoint(x: 50 * (i + 1) + 5*i, y: Int(size.height) - 80)
                addChild(hpHeart)
                heartSprites.append(hpHeart)
            }
            return true
        }
        return false
    }
    
    
    func checkGameOver() -> Bool {
        if(player.hp <= 0) {
            if(UserDefaults.standard.integer(forKey: "highscore") < player.points) {
                UserDefaults.standard.setValue(player.points, forKey: "highscore")
            }
            UserDefaults.standard.setValue(player.points, forKey: "lastscore")
            return true
        }
        return false
    }
    
    func gameOver() {
        self.isPaused.toggle()
        if let interstitial = self.interstitial {
            if let viewController = self.view?.window?.rootViewController {
                interstitial.present(fromRootViewController: viewController)
            }
        } else {
            print("ad wasn't ready")
            presentMenuScene()
        }
    }
    
    //new
    func togglePause() {
        pauseStatus.toggle()
        
        if(pauseStatus) {
            self.physicsWorld.gravity = CGVector.zero
            self.physicsWorld.speed = 0
        } else {
            self.isPaused = false
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            self.physicsWorld.speed = 1.0
        }
        for slime in slimes {
            slime.node.isPaused = pauseStatus
        }
        for ghost in ghosts {
            ghost.node.isPaused = pauseStatus
        }
        player.node.isPaused = pauseStatus
        spawnNode.isPaused = pauseStatus
    }
    
    
    
    func calculatePlayerMovement() {
        if(activeTouches.values.contains(leftButton)) {
            player.movePlayer(direction: -1, maxWidth: size.width)
        }
        if(activeTouches.values.contains(rightButton)) {
            player.movePlayer(direction: 1, maxWidth: size.width)
            
        }
    }
    func calculateEnemyMovement() {
        for slime in slimes {
            if(slime.node.position.x >= size.width + 10/* || slime.node.position.x <= -10*/) {
                slime.node.position.x = size.width
                //slime.node.position.y = size.height + slime.node.size.height
            }
            if(slime.node.position.x <= -10) {
                slime.node.position.x = -10
            }
            slime.moveEnemy(direction: player.node.position.x >= slime.node.position.x ? 1 : -1)
        }
        for ghost in ghosts {
            ghost.moveEnemy(direction: player.node.position.x >= ghost.node.position.x ? 1 : -1)
        }
    }
    
    func spawnEnemy() {
        let spawn = SKAction.run { [weak self] in
            let diff = self?.dificulty ?? 1
            let health = diff
            let newSlime = Slime(hp: 1 + health, damage: 1, speed: CGFloat(8 + diff/2), level: diff)
            let leftCorner = CGPoint(x: 0, y: (self?.ground.position.y ?? 0) + newSlime.node.size.height / 2 * 1.2)
            let rightCorner = CGPoint(x: self?.size.width ?? 0, y: (self?.ground.position.y ?? 0) + newSlime.node.size.height / 2 * 1.2)
            
            let spawnPosition1 = Bool.random() ? rightCorner : leftCorner
            var spawnPosition2 = Bool.random() ? rightCorner : leftCorner
            
            
            spawnPosition2.y += (self?.size.height ?? 0)/4
            newSlime.node.position = spawnPosition1
            if(self?.slimes.count ?? 0 <= 4 + diff ) {
                self?.slimes.append(newSlime)
                self?.addChild(newSlime.node)
            }
            //new for adding ghost
            if((diff >= 2) && (self?.ghosts.count ?? 0 < diff)) {
                let newGhost = Ghost(hp: Int(health), damage: 1, speed: CGFloat((60 + diff)))
                newGhost.node.position = spawnPosition2
                self?.ghosts.append(newGhost)
                self?.addChild(newGhost.node)
            }
        }
        spawnNode.run(SKAction.repeatForever(SKAction.group([spawn, SKAction.wait(forDuration: 2.5)])))
    }
    func increaseScore() {
        player.increaseScore(points: dificulty)
        scoreNode.text = "\(player.points)"
    }
    func increaseCombo() {
        if(player.combo == 0) {
            comboLabel.text = ""
        } else {
            comboLabel.text = "\(player.combo)"
        }
        comboLabel.fontColor = generateColor(level: player.combo)
    }
    func openShop() {
        shopOpen = true
        let newSword = arc4random_uniform(3)
        var type = SwordType.basic
        switch newSword {
        case 0:
            type = .katana
        case 1:
            type = .void
        case 2:
            type = .dagger
        default:
            type = .void
            
        }
        
        player.changeSword(sword: Sword(damage: 2, size: size, type: type), size: size)
        closeShop()
    }
    
    func closeShop() {
        let action = SKAction.run {
            self.merchant?.node.removeFromParent()
            self.merchant = nil
        }
        self.shopOpen = false
        merchant?.node.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), action]))
    }
    
    func loadInterstitialAd() {
        let adUnitID = "your-ad-unit-id" // Coloque aqui o ID do seu bloco de anúncios
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
            self?.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    func presentMenuScene() {
        let scene = MenuScene(size: self.size)
        scene.scaleMode = self.scaleMode
        self.view?.presentScene(scene)
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        // Ad foi fechado, mudar para a próxima cena
        presentMenuScene()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad failed to present with error: \(error.localizedDescription)")
        // Se o anúncio falhar ao ser apresentado, mudar para a próxima cena
        presentMenuScene()
    }
}

