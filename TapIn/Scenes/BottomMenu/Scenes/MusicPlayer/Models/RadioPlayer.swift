/*

import SwiftUI
import RealmSwift
import AVKit

class RadioPlayer {
    var radioChannel: RadioChannelModel
    var manager: RadioState
    var player: AVAudioPlayer!
    var timer: Timer!
    
    init(radioChannel: RadioChannelModel, manager: RadioState) {
        self.radioChannel = radioChannel
        self.manager = manager
        self.player = self.radioChannel.getSong()!
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timerEvent()
        }
    }
    
    private func timerEvent() {
        if player.currentTime >= player.duration {
            self.player = self.radioChannel.getSong()!
            self.play()
        }
    }
    
    func play() {
        self.player.play()
        
        manager.radioIsPlaying = true
    }
    
    func pause() {
        self.player.pause()
        
        manager.radioIsPlaying = false
    }
}


*/
