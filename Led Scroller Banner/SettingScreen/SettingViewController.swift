//
//  SettingViewController.swift
//  Led Scroller Banner
//
//  Created by Raza on 21/10/2024.
//
import UIKit
import AVFoundation
class SettingViewController: UIViewController {
    @IBOutlet var soundBtn: UIButton!
    var isMusicPlaying = false
    @IBOutlet var musicBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        AudioManager.shared.isMusicEnabled = UserDefaults.standard.bool(forKey: "isMusicEnabled")
                isMusicPlaying = UserDefaults.standard.bool(forKey: "isMusicPlaying") // Load saved image state
                updateButtonImage()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation

   
    @IBAction func soundPlayBtn(_ sender: Any) {
        AudioManager.shared.isMusicEnabled.toggle()
               
               // Save the music enabled state
               UserDefaults.standard.set(AudioManager.shared.isMusicEnabled, forKey: "isMusicEnabled")
               
               // Toggle and save the playing state
               if isMusicPlaying {
                   AudioManager.shared.stopMusic()
               } else {
                   AudioManager.shared.playMusic()
               }
               
               isMusicPlaying.toggle()
               UserDefaults.standard.set(isMusicPlaying, forKey: "isMusicPlaying") // Save image state
               updateButtonImage()
    }
    
    private func updateButtonImage() {
            let imageName = isMusicPlaying ? "sound on1" : "sound off1"
        soundBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    @IBAction func musicPlayBtn(_ sender: Any) {
        if AudioManager.shared.isMusicEnabled {
                   AudioManager.shared.playButtonClickSound()
               }
        
//        if isMusicPlaying {
//                    SoundManager.shared.stopSound()
//                } else {
//                    SoundManager.shared.playClickSound()
//                }
              //  isMusicPlaying.toggle()
            //   updateMusicButtonImage()
    }
    private func updateMusicButtonImage() {
           let musicImageName = isMusicPlaying ? "music on" : "music off"
           musicBtn.setImage(UIImage(named: musicImageName), for: .normal)
       }
}
