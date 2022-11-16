import Foundation

struct FormInputs {
    // MARK: Pomodoro
    
    var pomodoroDuration = 25
    var shortBreakDuration = 5
    var longBreakDuration = 15
    var longBreakFrequency = 3
    
    // MARK: Launcher
    
    var hideOnLaunch = false
    
    // MARK: Blocker
    
    var blockerStrength = BlockerStrength.normal
    
    init() {}
    
    init(folder: FolderDB) {
        // Pomodoro
        self.pomodoroDuration = folder.pomodoroSettings.pomodoroDuration
        self.shortBreakDuration = folder.pomodoroSettings.shortBreakDuration
        self.longBreakDuration = folder.pomodoroSettings.longBreakDuration
        self.longBreakFrequency = folder.pomodoroSettings.longBreakFrequency
        
        // Launcher
        self.hideOnLaunch = folder.launcherSettings.hideOnLaunch
        
        // Blocker
        self.blockerStrength = folder.blockerSettings.blockerStrength
    }
}
