//
//  UserConfig.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 06/06/24.
//

import Foundation

class UserConfig {
    static let shared: UserConfig = UserConfig()
    var sound: Bool
    var vibration: Bool
    var userPause: Bool
    
    init() {
        self.sound = true
        self.vibration = true
        self.userPause = false
    }
    
    func changeSound() {
        sound.toggle()
    }
    func changeVibration() {
        vibration.toggle()
    }
    func changePause() {
        userPause.toggle()
    }
}
