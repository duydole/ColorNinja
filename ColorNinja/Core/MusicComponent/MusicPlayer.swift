//
//  MusicPlayer.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import AVFoundation

class GameMusicPlayer {
    
    static let shared = GameMusicPlayer()
    
    var audioPlayer: AVAudioPlayer?
    
    var isMuteMainSound: Bool {
        return audioPlayer?.volume == 0
    }
    
    func startBackgroundMusic() {
        if let bundle = Bundle.main.path(forResource: "bgmusic", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    
    func playCorrectSound() {
        let filePath = Bundle.main.path(forResource: "correctsound", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: filePath!)
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }

    func playInCorrectSound() {
        let filePath = Bundle.main.path(forResource: "incorrectsound", ofType: "mp3")
        let soundURL = NSURL(fileURLWithPath: filePath!)
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
    
    func muteBackgroundGameMusic() {
        audioPlayer?.volume = 0.0
    }
    
    func unmuteBackgroundGameMusic() {
        audioPlayer?.volume = 1.0
    }

    func toggleMainSoundState() {
        if isMuteMainSound {
            unmuteBackgroundGameMusic()
        } else {
            muteBackgroundGameMusic()
        }
    }
}
