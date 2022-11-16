import SwiftUI
import RealmSwift

fileprivate let channels: [RadioChannel] = [
    RadioChannel(key: "Classical", title: "Classical", numberOfSongs: 4),
    RadioChannel(key: "JazzyJazz", title: "Jazzy Jazz", numberOfSongs: 3),
    RadioChannel(key: "Dramatic", title: "Dramatic", numberOfSongs: 3),
]

final class RadioState: WorkspaceComponentViewModel {
    
    // MARK: Main properties
    
    @IndexingCollection(collectionLength: channels.count)
    private var currentChannelIndex: Int = 0 {
        didSet {
            currentChannel = channels[currentChannelIndex]
            UserDefaultsManager.main.radioChannelIndex = currentChannelIndex
        }
    }
    
    @Published var currentChannel: RadioChannel
    
    private var player: RadioPlayer? = nil
    
    // MARK: Init
    
    init(workspace: WorkspaceDB) {
        let currentChannelIndex = UserDefaultsManager.main.radioChannelIndex
        self.currentChannelIndex = currentChannelIndex
        self.currentChannel = channels[currentChannelIndex]
        
        super.init(workspace: workspace, realm: RealmManager.shared.realm, component: .radio)
        
        initializePlayer()
    }
    
    // MARK: Changing channel
    
    func goToPrevChannel() {
        currentChannelIndex -= 1
        self.initializePlayer()
    }
    
    func goToNextChannel() {
        currentChannelIndex += 1
        self.initializePlayer()
    }
    
    // MARK: Stop and start session
    
    override func startSession() {
        super.startSession()
        player?.play()
    }
    
    override func endSession() {
        super.endSession()
        player?.pause()
    }
    
    private func initializePlayer() {
        self.player = RadioPlayer(channel: currentChannel, isPlaying: isActive)
    }
    
    deinit {
        print("WAS DEINITIALIZED")
    }
}
