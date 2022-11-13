import RealmSwift

// Create a simple Realm model called FolderDB
class FolderDB: RealmObject {
    @Persisted
    var name: String
    
    @Persisted
    var workspaces: List<WorkspaceDB>
    
    // MARK: Settings
    
    @Persisted
    var pomodoroSettings: PomodoroSettings!
    
    @Persisted
    var launcherSettings: LauncherSettings!
    
    @Persisted
    var blockerSettings: BlockerSettings!
    
    @Persisted
    var cascadingSettings: CascadingSettings!

    convenience init(name: String = "New Folder") {
        self.init()
        self.name = name
        self.pomodoroSettings = PomodoroSettings()
        self.launcherSettings = LauncherSettings()
        self.blockerSettings = BlockerSettings()
        self.cascadingSettings = CascadingSettings()
    }
    
    func updateSettings(with formInputs: FormInputs) {
        // Update default settings
        pomodoroSettings.pomodoroDuration = formInputs.pomodoroDuration
        pomodoroSettings.shortBreakDuration = formInputs.shortBreakDuration
        pomodoroSettings.longBreakDuration = formInputs.longBreakDuration
        pomodoroSettings.longBreakFrequency = formInputs.longBreakFrequency
        
        blockerSettings.blockerStrength = formInputs.blockerStrength
        
        launcherSettings.hideOnLaunch = formInputs.hideOnLaunch
        
        let set = MutableSet<WorkspaceTab>()
        set.insert(objectsIn: formInputs.pomodoroStartCascade)
        cascadingSettings.pomodoroStartCascade = set
        
        set.removeAll()
        set.insert(objectsIn: formInputs.pomodoroPauseCascade)
        cascadingSettings.pomodoroPauseCascade = set
        
        set.removeAll()
        set.insert(objectsIn: formInputs.pomodoroEndCascade)
        cascadingSettings.pomodoroEndCascade = set
        
        // Update child workspaces
        for workspace in workspaces
        {
            workspace.pomodoro.pomodoroDuration = formInputs.pomodoroDuration
            workspace.pomodoro.shortBreakDuration = formInputs.shortBreakDuration
            workspace.pomodoro.longBreakDuration = formInputs.longBreakDuration
            workspace.pomodoro.longBreakFrequency = formInputs.longBreakFrequency
            
            workspace.blocker.blockerStrength = formInputs.blockerStrength
            
            workspace.launcher.hideOnLaunch = formInputs.hideOnLaunch
        }
    }
}

class PomodoroSettings: EmbeddedObject {
    @Persisted
    var pomodoroDuration: Int = 25

    @Persisted
    var shortBreakDuration: Int = 5

    @Persisted
    var longBreakDuration: Int = 15

    @Persisted
    var longBreakFrequency: Int = 3
}

class LauncherSettings: EmbeddedObject {
    @Persisted
    var hideOnLaunch: Bool = false
}

class BlockerSettings: EmbeddedObject {
    @Persisted
    var blockerStrength: BlockerStrength = BlockerStrength.normal
}

class CascadingSettings: EmbeddedObject {
    @Persisted
    var pomodoroStartCascade = MutableSet<WorkspaceTab>()
    
    @Persisted
    var pomodoroPauseCascade = MutableSet<WorkspaceTab>()
    
    @Persisted
    var pomodoroEndCascade = MutableSet<WorkspaceTab>()
    
    override init() {
        super.init()
        
        pomodoroStartCascade.insert(objectsIn: [WorkspaceTab.timetracking, WorkspaceTab.blocker])
        pomodoroPauseCascade.insert(objectsIn: [WorkspaceTab.timetracking])
        pomodoroEndCascade.insert(objectsIn: [WorkspaceTab.timetracking, WorkspaceTab.blocker])
    }
}
