import Foundation
import AVKit

enum RadioError: Error {
    case IncorrectAssetPath
    case ChannelHasNoSongs
}

struct RadioSong {
    let file: String
    let title: String
    let singers: [String]
    
    var filePath: String {
         return "RadioChannels/\(file)"
     }

    func getAudioPlayer() throws -> AVAudioPlayer {
        guard let data = NSDataAsset(name: filePath)?.data else {
            throw RadioError.IncorrectAssetPath
        }
        
        return try AVAudioPlayer(data: data)
    }
    
    init(file: String, title: String = "Title", singer: String = "Artist") {
        self.file = file
        self.title = title
        self.singers = [singer]
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
        return "RadioChannels/Illustration_\(key)"
    }
    
    func getNextSong() -> RadioSong {
        return songs.randomElement()!
    }
}
