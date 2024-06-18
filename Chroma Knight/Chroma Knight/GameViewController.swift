//
//  GameViewController.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 28/05/24.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuScene = MenuScene(size: view.bounds.size)
        menuScene.scaleMode = .aspectFill
        let skView = self.view as! SKView
        
        skView.presentScene(menuScene)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
}
