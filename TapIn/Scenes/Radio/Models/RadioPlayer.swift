import Foundation
import AVKit

class RadioPlayer: NSObject, AVAudioPlayerDelegate {
    let song: RadioSong
    let player: AVAudioPlayer!
    let delegate: SimpleAudioPlayerDelegate
    
    init(song: RadioSong, isPlaying: Bool, delegate: SimpleAudioPlayerDelegate) {
        self.song = song
        self.player = try! song.getAudioPlayer()
        
        if isPlaying {
            self.player.play()
        } else {
            self.player.pause()
        }
        
        self.delegate = delegate
        
        super.init()
        
        self.player.delegate = self
    }
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
    
//    var isPlaying: Bool {
//        return self.player.isPlaying
//    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.delegate.audioPlayerDidFinishPlaying(player, successfully: flag)
    }
}
