import SwiftUI
import RealmSwift

final class RadioState: WorkspaceComponentViewModel {
    private let channels: [RadioChannel] = [
//        RadioChannel(key: "LofiBeats", title: "Lofi Beats", numberOfSongs: 0),
        RadioChannel(key: "Classical", title: "Classical", numberOfSongs: 4),
//        RadioChannel(key: "DarkAcademia", title: "Dark Academia", numberOfSongs: 0),
//        RadioChannel(key: "TechnoBops", title: "Techno Bops", numberOfSongs: 0),
        RadioChannel(key: "JazzyJazz", title: "Jazzy Jazz", numberOfSongs: 3),
        RadioChannel(key: "Dramatic", title: "Dramatic", numberOfSongs: 3),
//        RadioChannel(key: "GregorianChants", title: "Gregorian Chants", numberOfSongs: 0)
    ]
    
    @Published var currentChannelIndex: Int = 0 {
        didSet {
            currentChannel = channels[currentChannelIndex]
        }
    }
    
    @Published var currentChannel: RadioChannel
    
    var player: RadioPlayer? = nil
    
    init(workspace: WorkspaceDB) {
        self.currentChannelIndex = 0
        self.currentChannel = channels[0]
        
        super.init(workspace: workspace, realm: RealmManager.shared.realm)
        
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
    
    // MARK: Stop and start session
    
    // These properties and methods could have better names (i.e. radioIsPlaying, startPlayer, endPlayer) but in the interest of keeping naming uniform they are named
    // like this.
    
    @Published var isActive = false
    
    func startSession() {
        player?.play()
        isActive = true
        sendStatusChangeNotification(status: .running)
    }
    
    func endSession() {
        player?.pause()
        isActive = false
        sendStatusChangeNotification(status: .initial)
    }
    
    func initializePlayer() {
        self.player = RadioPlayer(channel: currentChannel, isPlaying: isActive)
    }
    
    deinit {
        print("WAS DEINITIALIZED")
    }
}
