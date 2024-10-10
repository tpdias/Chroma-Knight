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
    private var isPlaying: Bool = false
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
        SoundManager.soundTrack.audioPlayer?.stop()
        SoundManager.shared.audioPlayer?.stop()
        SoundManager.soundTrack.isPlaying = false
    }
    
    func changeSound() {
        SoundManager.shared.soundEnabled.toggle()
        SoundManager.soundTrack.soundEnabled.toggle()
        if(!SoundManager.shared.soundEnabled) {
            SoundManager.shared.stopSounds()
        }
        if(!SoundManager.soundTrack.soundEnabled) {
            SoundManager.soundTrack.stopSounds()
            SoundManager.soundTrack.isPlaying = false
        }
    }
    func playSoundtrack() {
        if(!isPlaying && soundEnabled) {
            playAudio(audio: "backgroundMusic", loop: true, volume: 0.3)
            isPlaying = true    
        }
    }
    func playButtonSound() {
        if(soundEnabled) {
            playAudio(audio: "button", loop: false, volume: 0.5)
        }
    }
    func playToggleSound() {
        if(soundEnabled) {
            playAudio(audio: "toggle", loop: false, volume: 0.5)
        }
    }
}
