import SwiftUI
import RealmSwift
import AVKit

//class RadioPlayer {
//    var radioChannel: RadioChannel
//    var player: AVAudioPlayer?
//    var timer: Timer
//    
//    init(radioChannel: RadioChannel) {
//        self.radioChannel = radioChannel
//        self.player = self.radioChannel.getSong()!
//        
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            self.timerEvent()
//        }
//    }
//    
//    private func timerEvent() {
//        if player.currentTime >= player.duration {
//            self.player = self.radioChannel.getSong()!
//            self.play()
//        }
//    }
//    
//    func play() {
//        self.player.play()
//        
//        manager.radioIsPlaying = true
//    }
//    
//    func pause() {
//        self.player.pause()
//        
//        manager.radioIsPlaying = false
//    }
//}
