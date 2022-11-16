import SwiftUI
import RealmSwift

struct ActiveBottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceState

    var body: some View {
        HStack(alignment: .center) {
            navigateButton(.left)
            
            Spacer()

            switch workspace.bottomMenuTab
            {
            case .pomodoro:
                PomodoroBottomMenuController()
                    .padding()
            case .launcher:
                LauncherBottomMenuController()
                    .padding()
            case .blocker:
                BlockerBottomMenuController()
                    .padding()
            case .radio:
                RadioBottomMenuController()
            default:
                EmptyView()
            }
            
            Spacer()
            
            navigateButton(.right)
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func navigateButton(_ direction: Direction) -> some View {
        if direction == .left
        {
            Button(action: { workspace.bottomMenuTab.previous() }, label: {
                Image(systemName: IconKeys.left)
            })
        }
        else
        {
            Button(action: { workspace.bottomMenuTab.next() }, label: {
                Image(systemName: IconKeys.right)
            })
        }
    }
}

struct BlockerBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: BlockerState {
        workspace.blocker
    }
    
    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .blocker) {
            HStack {
                if vm.isActive
                {
                    Button("Stop Blocking") {
                        vm.requestEndSession(sessionIsInProgress: workspace.componentActivityTracker.sessionIsInProgress())
                    }
                    .errorAlert(error: $workspace.blocker.error)
                }
                else
                {
                    Button("Start Blocking") {
                        vm.startSession()
                    }
                }
            }
        }
    }
}

struct LauncherBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .launcher) {
            Button("Launch") {
                workspace.launcher.openAll()
            }
        }
    }
}

struct PomodoroBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState

    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .pomodoro) {
            HStack {
                ForEach(workspace.pomodoro.getButtons(), id: \.rawValue) { button in
                    PomodoroButtonView(button: button)
                }
            }
        }
    }
}

struct PomodoroButtonView: View {
    @EnvironmentObject var workspace: WorkspaceState
    let button: PomodoroButton
    
    var body: some View {
        switch button
        {
        case .start, .resume:
            ButtonWithPopover(buttonTitle: button.rawValue, buttonAction: workspace.pomodoro.startSession, popover: {
                CascadingSettingsPopoverView(tabs: [.launcher, .blocker, .radio], keypath: \.cascadingStart, action: "start")
            })
        case .pause:
            ButtonWithPopover(buttonTitle: button.rawValue, buttonAction: workspace.pomodoro.pauseSession, popover: {
                CascadingSettingsPopoverView(tabs: [.blocker, .radio], keypath: \.cascadingPause, action: "pause")
            })
        case .cancel:
            ButtonWithPopover(buttonTitle: button.rawValue, buttonAction: workspace.pomodoro.cancelSession, popover: {
                CascadingSettingsPopoverView(tabs: [.blocker, .radio], keypath: \.cascadingStop, action: "stop")
            })
        case .skip:
            Button(button.rawValue, action: workspace.pomodoro.cancelSession)
        }
    }
}

struct CascadingSettingsPopoverView: View {
    @State private var tabs: [WorkspaceTab]
    @State private var selectedTabs: Set<WorkspaceTab> = Set()
    private let keypath: WritableKeyPath<UserDefaultsManager, Set<WorkspaceTab>>
    private let action: String
    
    init(tabs: [WorkspaceTab], keypath: WritableKeyPath<UserDefaultsManager, Set<WorkspaceTab>>, action: String) {
        self.tabs = tabs
        self.keypath = keypath
        self.action = action
    }
    
    func insert(_ tab: WorkspaceTab) {
        selectedTabs.insert(tab)
        UserDefaultsManager.main[keyPath: keypath] = Set(Array(selectedTabs))
    }
    
    func remove(_ tab: WorkspaceTab) {
        selectedTabs.remove(tab)
        UserDefaultsManager.main[keyPath: keypath] = Set(Array(selectedTabs))
    }
    
    func contains(_ tab: WorkspaceTab) -> Bool {
        selectedTabs.contains(tab)
    }

    var body: some View {
        Form {
            Section("Cascading Options") {
                Text("Also \(action) the following ...")
                
                ForEach(tabs, id: \.self) { tab in
                    Toggle(tab.label, isOn: Binding(
                        get: { contains(tab) },
                        set: { val,_ in
                            val ? insert(tab) : remove(tab)
                        }
                    ))
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 240)
        .onAppear {
            selectedTabs = UserDefaultsManager.main[keyPath: keypath]
        }
    }
}


struct BottomMenuWorkspaceTabController<Content>: View where Content: View {
    let workspaceTab: WorkspaceTab
    let content: Content
    
    init(workspaceTab: WorkspaceTab, @ViewBuilder content: () -> Content) {
        self.workspaceTab = workspaceTab
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(workspaceTab.label).font(.body)
            
            content
        }
    }
}

       
