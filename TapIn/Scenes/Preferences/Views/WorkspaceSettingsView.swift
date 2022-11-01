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
            if selectedWorkspace == 0 {
                return
            }
            
            workspace = workspaces[selectedWorkspace - 1]
            inputs = Inputs(workspace: workspace!)
        }
    }
    @Published var workspace: WorkspaceDB? = nil
    
    @Published var inputs = Inputs()
    
    func setPomodoroValue<V>(input: KeyPath<Inputs, V>, destination: WritableKeyPath<PomodoroDB, V>) {
        guard
            let workspace = workspace,
            let workspace = workspace.thaw()
        else { return }
        
        try? realm.write {
            workspace.pomodoro[keyPath: destination] = inputs[keyPath: input]
        }
    }
    
    func setPomodoroDuration() {
        guard
            let workspace = workspace,
            let workspace = workspace.thaw()
        else { return }
        
        try? realm.write {
            workspace.pomodoro.pomodoroDuration = Double(inputs.pomodoroDuration * 60)
        }
    }
}

@propertyWrapper struct Clamped {
    var wrappedValue: Int {
        didSet {
            wrappedValue = max(min(wrappedValue, upper), lower)
        }
    }
    
    let lower: Int
    let upper: Int
    
    init(wrappedValue: Int, min: Int, max: Int) {
        self.wrappedValue = wrappedValue
        self.lower = min
        self.upper = max
    }
}

@propertyWrapper struct InMinutes {
    var wrappedValue: Int

    init(wrappedValue: Int) {
        self.wrappedValue = wrappedValue * 60
    }
}

struct Inputs {
    @InMinutes var pomodoroDuration: Int
    @InMinutes var shortBreakDuration: Int
    @InMinutes var longBreakDuration: Int
    @Clamped(min: 1, max: 10) var longBreakFrequency: Int = 3
    
    var pomodoroDurationTypeConverted: TimeInterval {
        Double(pomodoroDuration)
    }
    
    var shortBreakDurationTypeConverted: TimeInterval {
        Double(shortBreakDuration)
    }
    
    var longBreakDurationTypeConverted: TimeInterval {
        Double(shortBreakDuration)
    }
    
    var longBreakFrequencyTypeConverted: Int8 {
        Int8(shortBreakDuration)
    }
    
    init() {
        self.pomodoroDuration = 25
        self.shortBreakDuration = 5
        self.longBreakDuration = 15
        self.longBreakFrequency = 3
    }
    
    init(workspace: WorkspaceDB) {
        self.pomodoroDuration = Int(workspace.pomodoro.pomodoroDuration / 60)
        self.shortBreakDuration = Int(workspace.pomodoro.shortBreakDuration / 60)
        self.longBreakDuration = Int(workspace.pomodoro.longBreakDuration / 60)
        self.longBreakFrequency = Int(workspace.pomodoro.longBreakFrequency)
    }
}

struct WorkspaceSettingsView: View {
    @StateObject private var vm = WorkspaceSettingsModel()
    
    var body: some View {
        Form {
            Picker("Apply settings to workspace", selection: $vm.selectedWorkspace) {
                Text("Default").tag(0)
                
                ForEach(Array(zip(vm.workspaces.indices, vm.workspaces)), id: \.0) { idx, workspace in
                    Text(workspace.name).tag(idx + 1)
                }
            }
            
            Section("Pomodoro") {
                TextField("Pomodoro Duration (minutes)", value: $vm.inputs.pomodoroDuration, format: .number)
                    .onSubmit {
                        vm.setPomodoroValue(input: \.pomodoroDurationTypeConverted, destination: \.pomodoroDuration)
                    }
                
                TextField("Short Break Duration (minutes)", value: $vm.inputs.shortBreakDuration, format: .number)
                    .onSubmit {
                        vm.setPomodoroValue(input: \.shortBreakDurationTypeConverted, destination: \.shortBreakDuration)
                    }
                
                TextField("Long Break Duration (minutes)", value: $vm.inputs.longBreakDuration, format: .number)
                    .onSubmit {
                        vm.setPomodoroValue(input: \.longBreakDurationTypeConverted, destination: \.longBreakDuration)
                    }
            }
            
            //            Section("Time tracker") {
            //
            //            }
            //
            //            Section("Launcher") {
            //
            //            }
            //
            //            Section("Blocker") {
            //
            //            }
        }
    }
}

struct WorkspaceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkspaceSettingsView()
    }
}
