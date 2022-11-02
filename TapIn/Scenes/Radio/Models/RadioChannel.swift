import Foundation
import AVKit

enum RadioError: Error {
    case IncorrectAssetPath
    case ChannelHasNoSongs
}

struct RadioSong {
    let file: String
    let title: String = "Song title"
    let singers: [String] = ["Beethoven"]
    
    func getAudioPlayer(with radioChannelKey: String) throws -> AVAudioPlayer {
        let filePath = "RadioChannels/\(radioChannelKey)/\(file)"
        
        guard let data = NSDataAsset(name: filePath)?.data else {
            throw RadioError.IncorrectAssetPath
        }
        
        return try AVAudioPlayer(data: data)
    }
}

struct RadioChannel {
    let key: String
    let title: String
    var songs: [RadioSong] = []
    
    init(key: String, title: String, songs: [RadioSong] = []) {
        self.key = key
        self.title = title
        self.songs = songs
    }
    
    init(key: String, title: String, numberOfSongs: Int) {
        self.key = key
        self.title = title
        
        var songs = [RadioSong]()
        for i in 0..<numberOfSongs {
            songs.append(RadioSong(file: "song-\(i + 1)"))
        }
        self.songs = songs
    }
    
    func getIllustrationImage() -> String {
        return "RadioChannels/\(key)/Illustration"
    }
    
    func getNextSong() throws -> AVAudioPlayer {
        guard let song = songs.randomElement() else {
            throw RadioError.ChannelHasNoSongs
        }
        
        return try song.getAudioPlayer(with: key)
    }

}
