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
    
    init() {
        self.sound = true
        self.vibration = true
    }
    
    func changeSound() {
        sound.toggle()
    }
    func changeVibration() {
        vibration.toggle()
    }
}
