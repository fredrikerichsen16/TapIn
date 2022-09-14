import SwiftUI
import Combine
import RealmSwift
import AVKit

class StateManager: ObservableObject {
    
    init() {
        self.radioManager = RadioManager(self)
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    @Published var sidebarSelection: String? = "home"
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Pomodoro
    
    private let pomodoroStatesHolder = PomodoroStatesHolder()
    
    func getPomodoroState(realm: Realm, ws: WorkspaceDB) -> PomodoroState {
        return pomodoroStatesHolder.getPomodoroState(realm: realm, ws: ws, stateManager: self)
    }
    
    func getActivePomodoro() -> PomodoroState? {
        return pomodoroStatesHolder.getActivePomodoro()
    }
    
    // MARK: Music Player
    
    var radioManager: RadioManager!
    
    @Published var radioIsPlaying: Bool = false
    @Published var currentChannel: String = ""
    
}

class RadioManager {
    private let channels: [RadioChannelModel] = [
        try! RadioChannelModel(keyname: "piano", label: "Relaxing Piano"),
        try! RadioChannelModel(keyname: "lofi", label: "Lofi Beats"),
        try! RadioChannelModel(keyname: "techno", label: "Techno Bops"),
        try! RadioChannelModel(keyname: "jazz", label: "Jazzy Jazz")
    ]
    private var activeChannelIndex: Int = 0
    private var radioPlayer: RadioPlayer!
    let stateManager: StateManager
    
    init(_ stateManager: StateManager) {
        self.stateManager = stateManager
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
        
        stateManager.currentChannel = getActiveChannel().label
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

class RadioPlayer {
    var radioChannel: RadioChannelModel
    var manager: RadioManager
    var player: AVAudioPlayer!
    var timer: Timer!
    
    init(radioChannel: RadioChannelModel, manager: RadioManager) {
        self.radioChannel = radioChannel
        self.manager = manager
        self.player = self.radioChannel.getSong()!
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timerEvent()
        }
    }
    
    private func timerEvent() {
        if player.currentTime >= player.duration {
            self.player = self.radioChannel.getSong()!
            self.play()
        }
    }
    
    func play() {
        self.player.play()
        
        manager.stateManager.radioIsPlaying = true
    }
    
    func pause() {
        self.player.pause()
        
        manager.stateManager.radioIsPlaying = false
    }
}
