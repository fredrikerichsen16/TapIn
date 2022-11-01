import SwiftUI
import RealmSwift

final class RadioState: ObservableObject {
    var workspace: WorkspaceDB
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    func isActive() -> Bool {
        return radioIsPlaying
    }
    
    private let channels: [RadioChannelModel] = [
        try! RadioChannelModel(keyname: "piano", label: "Dark Academia", image: "DarkAcademia"),
        try! RadioChannelModel(keyname: "piano", label: "Lofi Beats", image: "Classical"),
        try! RadioChannelModel(keyname: "piano", label: "Techno Bops", image: "Classical"),
        try! RadioChannelModel(keyname: "piano", label: "Jazzy Jazz", image: "Classical"),
        try! RadioChannelModel(keyname: "piano", label: "Gregorian Chants", image: "GregorianChants")
    ]
    private var activeChannelIndex: Int = 0
    private var radioPlayer: RadioPlayer!
    
    @Published var currentChannel: String = ""
    @Published var radioIsPlaying: Bool = false {
        didSet
        {
//            stateManager.refreshActiveWorkspace()
        }
    }
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.radioPlayer = radioPlayerConstructor()
    }
    
    private func radioPlayerConstructor() -> RadioPlayer {
        return RadioPlayer(radioChannel: getActiveChannel(), manager: self)
    }
    
    func getActiveChannel() -> RadioChannelModel {
        return channels[activeChannelIndex]
    }
    
    func getActivePlayer() -> RadioPlayer {
        return radioPlayer
    }
    
    private func changeChannel() {
        let isPlaying = self.radioPlayer.player.isPlaying
        
        self.radioPlayer = radioPlayerConstructor()
        
        if isPlaying
        {
            self.radioPlayer.play()
        }
        else
        {
            self.radioPlayer.pause()
        }
        
        currentChannel = getActiveChannel().label
    }
    
    func goToPrevChannel() {
        if activeChannelIndex == 0
        {
            activeChannelIndex = channels.count - 1
        }
        else
        {
            activeChannelIndex -= 1
        }
        
        changeChannel()
    }
    
    func goToNextChannel() {
        if activeChannelIndex == channels.count - 1
        {
            activeChannelIndex = 0
        }
        else
        {
            activeChannelIndex += 1
        }
        
        changeChannel()
    }
    
    func play() {
        radioPlayer.play()
    }
    
    func pause() {
        radioPlayer.pause()
    }
}
