import SwiftUI

struct FolderView: View {
    @EnvironmentObject var sidebarState: SidebarState
    @EnvironmentObject var folderState: FolderState
    
    var pomodoroNumberFormatter: ClampedFormatter = {
        return ClampedFormatter(min: 1, max: 240)
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Folder Settings")
                        .font(.title)
                    Text("Set folder information and also apply default preferences that apply to all workspaces in this folder")
                        .foregroundColor(.gray)
                }
                
                Form {
                    Section("Folder") {
                        TextField("Folder Name", text: $folderState.folder.name)
                        HStack {
                            Button("Add workspace") {
                                sidebarState.addWorkspace(to: folderState.folder)
                            }
                            
                            Button("Delete folder") {
                                sidebarState.delete(folder: folderState.folder)
                            }
                        }
                    }
                    
                    Section("Pomodoro") {
                        TextField("Pomodoro Duration (minutes)", value: $folderState.formInputs.pomodoroDuration, formatter: pomodoroNumberFormatter)
                        
                        TextField("Short Break Duration (minutes)", value: $folderState.formInputs.shortBreakDuration, formatter: pomodoroNumberFormatter)
                        
                        TextField("Long Break Duration (minutes)", value: $folderState.formInputs.longBreakDuration, formatter: pomodoroNumberFormatter)
                        
                        TextField("Long Break Frequency", value: $folderState.formInputs.longBreakFrequency, formatter: pomodoroNumberFormatter)
                    }
                    
                    Section("Launcher") {
                        Toggle("Hide app on launch by default", isOn: $folderState.formInputs.hideOnLaunch)
                    }
                    
                    Section("Blocker") {
                        Picker(selection: $folderState.formInputs.blockerStrength, content: {
                            ForEach(BlockerStrength.allCases, id: \.self) { strength in
                                Text(strength.label).tag(strength)
                            }}, label: {
                                Text("Content Blocker Strength")
                                Text(getContentBlockerStrengthValueExplanation())
                            })
                        .pickerStyle(.inline)
                    }
                    
                    cascadingSettingsSection
                    
                    Button("Save changes") {
                        folderState.onSubmit()
                    }
                }
                .formStyle(.grouped)
                
                Spacer()
            }
        }
        .padding(25)
    }
    
    func getContentBlockerStrengthValueExplanation() -> String {
        let blockerStrength = folderState.formInputs.blockerStrength
        
        return "\(blockerStrength.label): \(blockerStrength.getExplanation())"
    }
}

extension FolderView {
    var cascadingSettingsSection: some View {
        Section(content: {
            // Pomodoro Start
            Text("When you start the pomodoro session, automatically start the following ...")
            
            ForEach(Array(zip([1, 2, 3, 4], [WorkspaceTab.timetracking, WorkspaceTab.launcher, WorkspaceTab.blocker, WorkspaceTab.radio])), id: \.0) { _, tab in
                Toggle(tab.label, isOn: Binding(
                    get: { folderState.formInputs.pomodoroStartCascade.contains(tab) },
                    set: { val,_ in
                        if val {
                            folderState.formInputs.pomodoroStartCascade.insert(tab)
                        } else {
                            folderState.formInputs.pomodoroStartCascade.remove(tab)
                        }
                    }
                ))
            }
            
            Text("When you pause the pomodoro session, automatically pause the following ...")
            
            ForEach(Array(zip([11, 12, 13], [WorkspaceTab.timetracking, WorkspaceTab.blocker, WorkspaceTab.radio])), id: \.0) { _, tab in
                Toggle(tab.label, isOn: Binding(
                    get: { folderState.formInputs.pomodoroPauseCascade.contains(tab) },
                    set: { val,_ in
                        if val {
                            folderState.formInputs.pomodoroPauseCascade.insert(tab)
                        } else {
                            folderState.formInputs.pomodoroPauseCascade.remove(tab)
                        }
                    }
                ))
            }
            
            Text("When you stop the pomodoro session, automatically stop the following ...")
            
            ForEach(Array(zip([21, 22, 23], [WorkspaceTab.timetracking, WorkspaceTab.blocker, WorkspaceTab.radio])), id: \.0) { _, tab in
                Toggle(tab.label, isOn: Binding(
                    get: { folderState.formInputs.pomodoroEndCascade.contains(tab) },
                    set: { val,_ in
                        if val {
                            folderState.formInputs.pomodoroEndCascade.insert(tab)
                        } else {
                            folderState.formInputs.pomodoroEndCascade.remove(tab)
                        }
                    }
                ))
            }
        }, header: {
            Text("Cascading Settings")
            Text("When you start/pause/end a pomodoro session, you can automatically start or end other components, like the time tracker or content blocker")
                .foregroundColor(.gray)
        })
    }
}








//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}
