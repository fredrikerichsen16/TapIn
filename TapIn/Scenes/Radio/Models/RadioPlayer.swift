import Foundation
import AVKit

class RadioPlayer: NSObject, AVAudioPlayerDelegate {
    let channel: RadioChannel
    var song: AVAudioPlayer
    
    init(channel: RadioChannel, isPlaying: Bool) {
        self.channel = channel
        self.song = try! channel.getNextSong()
        
        if isPlaying {
            self.song.play()
        } else {
            self.song.pause()
        }
        
        super.init()
        
        self.song.delegate = self
    }
    
    func play() {
        self.song.play()
    }
    
    func pause() {
        self.song.pause()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.song = try! channel.getNextSong()
        self.song.play()
    }
}
