//
//  AudioButtonManager.swift
//  Led Scroller Banner
//
//  Created by Raza on 23/10/2024.
//

import Foundation
import AVFoundation
class SoundManager {
    static let shared = SoundManager() 

    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playClickSound() {
        guard let soundURL = Bundle.main.url(forResource: "Doppelbass", withExtension: "mp3"),
              let audioPlayer = try? AVAudioPlayer(contentsOf: soundURL) else {
            print("Failed to load sound file")
            return
        }

        if UserDefaults.standard.bool(forKey: "isVolumeOn") {
            self.audioPlayer = audioPlayer
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } else {
            print("Volume switch is off, not playing sound.")
        }
    }

    func stopSound() {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
            audioPlayer = nil
        }
    }
}
