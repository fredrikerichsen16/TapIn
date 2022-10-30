import SwiftUI
import RealmSwift

final class RadioState: ObservableObject {
    var workspaceDB: WorkspaceDB
    var workspaceVM: WorkspaceVM
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    func isActive() -> Bool {
        return radioIsPlaying
    }
    
    private let channels: [RadioChannelModel] = [
        try! RadioChannelModel(keyname: "piano", label: "Relaxing Piano"),
        try! RadioChannelModel(keyname: "piano", label: "Lofi Beats"),
        try! RadioChannelModel(keyname: "piano", label: "Techno Bops"),
        try! RadioChannelModel(keyname: "piano", label: "Jazzy Jazz")
//        try! RadioChannelModel(keyname: "lofi", label: "Lofi Beats"),
//        try! RadioChannelModel(keyname: "techno", label: "Techno Bops"),
//        try! RadioChannelModel(keyname: "jazz", label: "Jazzy Jazz")
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
    
    init(workspaceVM: WorkspaceVM) {
        self.workspaceVM = workspaceVM
        self.workspaceDB = workspaceVM.workspace
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
