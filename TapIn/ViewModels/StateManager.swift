import SwiftUI
import Combine
import RealmSwift
import AVKit

class StateManager: ObservableObject {
    
    var timer: Timer?
    
    init() {
        let this = self
        
        radioChannels = [
           try! RadioChannelModel(keyname: "piano", label: "Relaxing Piano"),
           try! RadioChannelModel(keyname: "lofi", label: "Lofi Beats"),
           try! RadioChannelModel(keyname: "techno", label: "Techno Bops"),
           try! RadioChannelModel(keyname: "jazz", label: "Jazzy Jazz")
       ]
        
        timer = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            this.player?.timerEvent()
        }
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var sidebarSelection: String? = "home"
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Pomodoro
    
    private let pomodoroStatesHolder = PomodoroStatesHolder()
    
    func getPomodoroState(realm: Realm, ws: WorkspaceDB) -> PomodoroState {
        return pomodoroStatesHolder.getPomodoroState(realm: realm, ws: ws)
    }
    
    func getActivePomodoro() -> PomodoroState? {
        return pomodoroStatesHolder.getActivePomodoro()
    }
    
    // MARK: Music Player
    
    let radioChannels: [RadioChannelModel]
    var selectedRadioChannelIndex = 0
    var selectedRadioChannel: RadioChannelModel {
        radioChannels[selectedRadioChannelIndex]
    }
    
    func goToPrevChannel() {
        if selectedRadioChannelIndex == 0 {
            selectedRadioChannelIndex = radioChannels.count - 1
        } else {
            selectedRadioChannelIndex -= 1
        }
        
        self.player = nil
    }
    
    func goToNextChannel() {
        if selectedRadioChannelIndex == radioChannels.count - 1 {
            selectedRadioChannelIndex = 0
        } else {
            selectedRadioChannelIndex += 1
        }
        
        self.player = nil
    }
    
    var player: RadioPlayer?
    
    func startPlayer() {
        if let activePlayer = player
        {
            activePlayer.play()
        }
        else
        {
            do
            {
                player = try RadioPlayer(radioChannel: selectedRadioChannel)
            }
            catch
            {
                fatalError("Failed to start audio player")
            }
        }
    }
    
    func pausePlayer() {
        player?.pause()
    }
    
}

class RadioPlayer {
    var radioChannel: RadioChannelModel
    var player: AVAudioPlayer!
    
    init(radioChannel: RadioChannelModel) throws {
        self.radioChannel = radioChannel
        self.player = try! getNextSong()
        self.play()
    }
    
    func getNextSong() throws -> AVAudioPlayer {
        var songIndexes = Array(0..<radioChannel.numberOfSongsInChannel)
        
        if let lastPlayed = radioChannel.lastPlayedSongIndex,
           let index = songIndexes.firstIndex(of: lastPlayed) {
            songIndexes.remove(at: index)
        }
        
        guard let songToPlay = songIndexes.randomElement(),
              let songData = NSDataAsset(name: "\(radioChannel.keyname)-\(songToPlay)")?.data
        else {
            throw NSError(domain: "RadioPlayer", code: 1)
        }
        
        let audioPlayer = try! AVAudioPlayer(data: songData)
        
        return audioPlayer
    }
    
    func timerEvent() {
        if player.currentTime >= player.duration {
            do {
                self.player = try getNextSong()
                self.play()
            }
            catch {
                fatalError("Cannot get next song #427381038")
            }
        }
    }
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
    }
}
