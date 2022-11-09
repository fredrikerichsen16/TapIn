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
    
    // MARK: Cascading Start
    
    var pomodoroStartCascade: Set<WorkspaceTab> = Set([.timetracking])
    var pomodoroPauseCascade: Set<WorkspaceTab> = Set()
    var pomodoroEndCascade: Set<WorkspaceTab> = Set([.timetracking, .blocker])
    
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
        
        // Cascading
        self.pomodoroStartCascade = Set(folder.cascadingSettings.pomodoroStartCascade)
        self.pomodoroPauseCascade = Set(folder.cascadingSettings.pomodoroPauseCascade)
        self.pomodoroEndCascade = Set(folder.cascadingSettings.pomodoroEndCascade)
    }
}
