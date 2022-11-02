import SwiftUI
import RealmSwift

class WorkspaceSettingsModel: ObservableObject {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
    }
    
    @Published var workspaces: Results<WorkspaceDB>
    @Published var selectedWorkspace: Int = 0 {
        didSet {
            if selectedWorkspace == 0
            {
                workspace = nil
                inputs = Inputs()
                return
            }
            else
            {
                workspace = workspaces[selectedWorkspace - 1]
                inputs = Inputs(workspace: workspace!)
            }
        }
    }
    @Published var workspace: WorkspaceDB? = nil
    
    @Published var inputs = Inputs()
}

struct InputValue<T> {
    var useDefault = true
    var value: T
}

struct Inputs {
    // MARK: Pomodoro
    
    var pomodoroDuration = InputValue<Int>(useDefault: false, value: 25)
    var shortBreakDuration = InputValue<Int>(useDefault: false, value: 5)
    var longBreakDuration = InputValue<Int>(useDefault: false, value: 15)
    var longBreakFrequency = InputValue<Int>(useDefault: false, value: 3)
    
    // MARK: Time Tracker
    var trackPomodoroTime = InputValue<Bool>(useDefault: true, value: false)
    
    // MARK: Launcher
    var hideOnLaunch = InputValue<Bool>(useDefault: true, value: false)
    
    // MARK: Blocker
    var blockerStrength = InputValue<BlockerStrength>(useDefault: true, value: BlockerStrength.normal)
    
    init() {}
    
    init(workspace: WorkspaceDB) {
        // Pomodoro
        self.pomodoroDuration = InputValue<Int>(useDefault: false, value: workspace.pomodoro.pomodoroDuration)
        self.shortBreakDuration = InputValue<Int>(useDefault: false, value: workspace.pomodoro.shortBreakDuration)
        self.longBreakDuration = InputValue<Int>(useDefault: false, value: workspace.pomodoro.longBreakDuration)
        self.longBreakFrequency = InputValue<Int>(useDefault: false, value: workspace.pomodoro.longBreakFrequency)
        
        // Time Tracker
        self.trackPomodoroTime = InputValue<Bool>(useDefault: false, value: workspace.timeTracker.trackPomodoroTime)
        
        // Launcher
        self.hideOnLaunch = InputValue<Bool>(useDefault: false, value: false)
        
        // Blocker
        self.blockerStrength = InputValue<BlockerStrength>(useDefault: false, value: workspace.blocker.blockerStrength)
    }
}

class ClampedFormatter: Formatter {
    var lower: Int
    var upper: Int

    init(min: Int, max: Int) {
        self.lower = min
        self.upper = max
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(for obj: Any?) -> String? {
        guard let number = obj as? Int else {
            return nil
        }
        return String(number)
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        guard let number = Int(string) else {
            return false
        }
        
        obj?.pointee = max(min(number, upper), lower) as AnyObject
        
        return true
    }
}

struct WorkspaceSettingsView: View {
    @StateObject private var vm = WorkspaceSettingsModel()
    
    var pomodoroNumberFormatter: ClampedFormatter = {
        return ClampedFormatter(min: 1, max: 240)
    }()
    
//    var pomodoroNumberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//            formatter.minimum = NSNumber(value: 1)
//            formatter.maximum = NSNumber(value: 240)
//        return formatter
//    }()
    
    var body: some View {
        Form {
            Picker("Apply settings to workspace", selection: $vm.selectedWorkspace) {
                Text("Default").tag(0)
                
                ForEach(Array(zip(vm.workspaces.indices, vm.workspaces)), id: \.0) { idx, workspace in
                    Text(workspace.name).tag(idx + 1)
                }
            }
            
            Section("Pomodoro") {
                // Pomodoro Duration (minutes)
                Picker("Pomodoro Duration (minutes)", selection: $vm.inputs.pomodoroDuration.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.pomodoroDuration.useDefault == false {
                    TextField("", value: $vm.inputs.pomodoroDuration.value, formatter: pomodoroNumberFormatter)
                }
                
                // Short Break Duration (minutes)
                Picker("Short Break Duration (minutes)", selection: $vm.inputs.shortBreakDuration.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.shortBreakDuration.useDefault == false {
                    TextField("", value: $vm.inputs.shortBreakDuration.value, formatter: pomodoroNumberFormatter)
                }
                
                // Long Break Duration (minutes)
                Picker("Long Break Duration (minutes)", selection: $vm.inputs.longBreakDuration.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.longBreakDuration.useDefault == false {
                    TextField("", value: $vm.inputs.longBreakDuration.value, formatter: pomodoroNumberFormatter)
                }
                
                // Long Break Frequency
                Picker("Long Break Frequency", selection: $vm.inputs.longBreakFrequency.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.longBreakFrequency.useDefault == false {
                    TextField("", value: $vm.inputs.longBreakFrequency.value, formatter: pomodoroNumberFormatter)
                }
            }
                
            Section("Time tracker") {
                Picker("Automatically track pomodoro session time", selection: $vm.inputs.trackPomodoroTime.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.trackPomodoroTime.useDefault == false {
                    Toggle("", isOn: $vm.inputs.trackPomodoroTime.value)
                }
            }

            Section("Launcher") {
                Picker("Hide on launch by default", selection: $vm.inputs.hideOnLaunch.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.hideOnLaunch.useDefault == false {
                    Toggle("", isOn: $vm.inputs.hideOnLaunch.value)
                }
            }

            Section("Blocker") {
                Picker("Content Blocker Strength", selection: $vm.inputs.blockerStrength.useDefault) {
                    Text("Use default").tag(true)
                    Text("Set value").tag(false)
                }
                .pickerStyle(.inline)
                
                if vm.inputs.blockerStrength.useDefault == false {
                    Picker("", selection: $vm.inputs.blockerStrength.value) {
                        ForEach(BlockerStrength.allCases, id: \.self) { strength in
                            Text(strength.rawValue.capitalized).tag(strength)
                        }
                    }
                    .pickerStyle(.inline)
                }
            }
        }
        .formStyle(.grouped)
    }
}

struct WorkspaceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceSettingsView()
    }
}
