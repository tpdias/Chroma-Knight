//
//  UserConfig.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 06/06/24.
//

import Foundation

class UserConfig {
    static let shared: UserConfig = UserConfig()
    var vibration: Bool
    var userPause: Bool
    var isPlayingSoundtrack: Bool
    
    init() {
        self.vibration = true
        self.userPause = false
        self.isPlayingSoundtrack = false
    }
    

    func changeVibration() {
        vibration.toggle()
    }
    func changePause() {
        userPause.toggle()
    }
}
