//
//  AudioManager.swift
//  Led Scroller Banner
//
//  Created by Raza on 23/10/2024.
//
import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var audioPlayer: AVAudioPlayer?
    var buttonClickPlayer: AVAudioPlayer?
    
    var isMusicEnabled = true 
    private init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        if let path = Bundle.main.path(forResource: "ButtonVoice", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = 1
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file")
            }
        }
    }
    
    func playMusic() {
        audioPlayer?.play()
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
    
    func playButtonClickSound() {
        guard isMusicEnabled else { return } // Only play sound if enabled
        if let path = Bundle.main.path(forResource: "ButtonVoice", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                buttonClickPlayer = try AVAudioPlayer(contentsOf: url)
                buttonClickPlayer?.play()
            } catch {
                print("Error loading button click sound")
            }
        }
    }
}
