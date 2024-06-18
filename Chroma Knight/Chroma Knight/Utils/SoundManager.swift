//
//  SoundManager.swift
//  Chroma Knight
//
//  Created by Thiago Parisotto on 17/06/24.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    static let soundTrack = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    var soundEnabled: Bool = true
    
    func playAudio(audio: String, loop: Bool, volume: Float) {
        if(soundEnabled) {
            guard let audioURL = Bundle.main.url(forResource: audio, withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = loop ? -1 : 0
                audioPlayer?.play()
            } catch {
                print("Couldn't play audio. Error \(error)")
            }
        }
    }
    func stopSounds() {
        audioPlayer?.stop()
    }
    
    func changeSound() {
        soundEnabled.toggle()
        if(!soundEnabled) {
            self.stopSounds()
        }
    }
    func playSoundtrack() {
        SoundManager.shared.playAudio(audio: "backgroundMusic", loop: true, volume: 0.3)
    }
}
