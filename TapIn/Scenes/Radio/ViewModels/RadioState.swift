import SwiftUI
import RealmSwift

final class RadioState: ObservableObject {
    var workspace: WorkspaceDB
    var realm: Realm
    
    private let channels: [RadioChannel] = [
//        RadioChannel(key: "LofiBeats", title: "Lofi Beats", numberOfSongs: 0),
        RadioChannel(key: "Classical", title: "Classical", numberOfSongs: 4),
//        RadioChannel(key: "DarkAcademia", title: "Dark Academia", numberOfSongs: 0),
//        RadioChannel(key: "TechnoBops", title: "Techno Bops", numberOfSongs: 0),
        RadioChannel(key: "JazzyJazz", title: "Jazzy Jazz", numberOfSongs: 3),
        RadioChannel(key: "Dramatic", title: "Dramatic", numberOfSongs: 3),
//        RadioChannel(key: "GregorianChants", title: "Gregorian Chants", numberOfSongs: 0)
    ]
    
    var currentChannelIndex: Int = 0 {
        didSet {
            currentChannel = channels[currentChannelIndex]
        }
    }
    
    @Published var radioIsPlaying: Bool = false
    
    @Published var currentChannel: RadioChannel
    
    var player: RadioPlayer? = nil
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.realm = RealmManager.shared.realm
        self.currentChannelIndex = 0
        self.currentChannel = channels[0]
        
        initializePlayer()
    }
    
    func goToPrevChannel() {
        if currentChannelIndex == 0
        {
            currentChannelIndex = channels.count - 1
        }
        else
        {
            currentChannelIndex -= 1
        }
        
        self.initializePlayer()
    }
    
    func goToNextChannel() {
        if currentChannelIndex == channels.count - 1
        {
            currentChannelIndex = 0
        }
        else
        {
            currentChannelIndex += 1
        }
        
        self.initializePlayer()
    }
    
    func play() {
        player?.play()
        radioIsPlaying = true
    }
    
    func pause() {
        player?.pause()
        radioIsPlaying = false
    }
    
    func initializePlayer() {
        self.player = RadioPlayer(channel: currentChannel, isPlaying: radioIsPlaying)
    }
}


//final class RadioState: ObservableObject {
//    private var workspace: WorkspaceDB
//    private var realm: Realm
//
//    func isActive() -> Bool {
//        return radioIsPlaying
//    }
//
//    private let channels: [RadioChannel] = [
//        RadioChannel(key: "LofiBeats", title: "Lofi Beats", numberOfSongs: 0),
//        RadioChannel(key: "Classical", title: "Classical", numberOfSongs: 4),
//        RadioChannel(key: "DarkAcademia", title: "Dark Academia", numberOfSongs: 0),
//        RadioChannel(key: "TechnoBops", title: "Techno Bops", numberOfSongs: 0),
//        RadioChannel(key: "JazzyJazz", title: "Jazzy Jazz", numberOfSongs: 3),
//        RadioChannel(key: "Dramatic", title: "Dramatic", numberOfSongs: 0),
//        RadioChannel(key: "GregorianChants", title: "Gregorian Chants", numberOfSongs: 0)
//    ]
//
//    private var activeChannelIndex: Int = 0
//    private var radioPlayer: RadioPlayer!
//
//    @Published var currentChanelIndex: Int = 0
//
//    @Published var radioIsPlaying: Bool = false
//
//    var currentChannel: RadioChannel {
//        channels[currentChanelIndex]
//    }
//
//    init(workspace: WorkspaceDB) {
//        self.workspace = workspace
//        self.realm = RealmManager.shared.realm
//        self.radioPlayer = radioPlayerConstructor()
//    }
//
//    private func radioPlayerConstructor() -> RadioPlayer {
//        return RadioPlayer(radioChannel: getActiveChannel(), manager: self)
//    }
//
//    func getActiveChannel() -> RadioChannel {
//        return channels[activeChannelIndex]
//    }
//
//    func getActivePlayer() -> RadioPlayer {
//        return radioPlayer
//    }
//
//    private func changeChannel() {
//        let isPlaying = self.radioPlayer.player.isPlaying
//
//        self.radioPlayer = radioPlayerConstructor()
//
//        if isPlaying
//        {
//            self.radioPlayer.play()
//        }
//        else
//        {
//            self.radioPlayer.pause()
//        }
//
//        currentChannel = getActiveChannel().label
//    }
//
//    func goToPrevChannel() {
//        if activeChannelIndex == 0
//        {
//            activeChannelIndex = channels.count - 1
//        }
//        else
//        {
//            activeChannelIndex -= 1
//        }
//
//        changeChannel()
//    }
//
//    func goToNextChannel() {
//        if activeChannelIndex == channels.count - 1
//        {
//            activeChannelIndex = 0
//        }
//        else
//        {
//            activeChannelIndex += 1
//        }
//
//        changeChannel()
//    }
//
//    func play() {
//        radioPlayer.play()
//    }
//
//    func pause() {
//        radioPlayer.pause()
//    }
//}
