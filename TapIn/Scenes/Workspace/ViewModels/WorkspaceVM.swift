import Foundation
import Combine

class ComponentActivityTracker {
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    let workspace: WorkspaceVM
    
    init(workspace: WorkspaceVM) {
        self.workspace = workspace
        
        // Observing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.pomodoro)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.timeTracker)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.radio)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.blocker)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var componentsStatus: [WorkspaceTab: TimerMode] = [
        .pomodoro: .initial,
        .timetracking: .initial,
        .blocker: .initial,
        .radio: .initial
    ]
    
    private func getStatusAndComponent(from notification: Notification) -> (WorkspaceTab, TimerMode)? {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return nil
        }
        
        if let component = userInfo["component"] as? WorkspaceTab,
           let status = userInfo["status"] as? TimerMode
        {
            return (component, status)
        }
        
        return nil
    }
    
    @objc func componentDidChangeStatus(_ notification: Notification) {
        guard let (component, status) = getStatusAndComponent(from: notification) else {
            return
        }
        
        componentsStatus[component] = status
        
        if componentsStatus.values.contains(where: { $0.isActive() })
        {
            coordinator.setActive(workspace: workspace)
        }
        else
        {
            coordinator.disactivate()
        }
        
        if component == .pomodoro {
            cascade(status: status)
        }
        
        printStatus()
    }
    
    // MARK: Cascading
    
    func cascade(status: TimerMode) {
        let folder = workspace.workspace.folder
        var components: Set<WorkspaceTab> = Set()
        
        switch status
        {
        case .initial:
            components = Set(folder.cascadingSettings.pomodoroEndCascade)
        case .paused:
            components = Set(folder.cascadingSettings.pomodoroPauseCascade)
        case .running:
            components = Set(folder.cascadingSettings.pomodoroStartCascade)
        }
        
        switch status
        {
        case .initial, .paused:
            for component in components
            {
                switch component
                {
                case .timetracking:
                    workspace.timeTracker.endSession()
                case .blocker:
                    workspace.blocker.endSession()
                case .radio:
                    workspace.radio.endSession()
                default:
                    break
                }
            }
        case .running:
            for component in components
            {
                switch component
                {
                case .timetracking:
                    workspace.timeTracker.startSession()
                case .blocker:
                    workspace.blocker.startSession()
                case .radio:
                    workspace.radio.startSession()
                case .launcher:
                    workspace.launcher.openAll()
                default:
                    break
                }
            }
        }
    }
    
    func printStatus() {
        for (key, value) in componentsStatus
        {
            print("\(key.label): \(value)")
        }
    }
}

class WorkspaceVM: ObservableObject {
    static var preview: WorkspaceVM = {
        let realm = RealmManager.preview.realm
        let workspace = realm.objects(WorkspaceDB.self).first!
        let workspaceVM = WorkspaceVM(workspace: workspace)
        
        workspaceVM.pomodoro.realm = realm
        workspaceVM.timeTracker.realm = realm
        workspaceVM.radio.realm = realm
        workspaceVM.launcher.realm = realm
        workspaceVM.blocker.realm = realm
        
        return workspaceVM
    }()
    
    // MARK: Init
    
    var workspace: WorkspaceDB
    var componentActivityTracker: ComponentActivityTracker!
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.pomodoro = PomodoroState(workspace: workspace)
        self.timeTracker = TimeTrackerState(workspace: workspace)
        self.radio = RadioState(workspace: workspace)
        self.launcher = LauncherState(workspace: workspace)
        self.blocker = BlockerState(workspace: workspace)
        self.componentActivityTracker = ComponentActivityTracker(workspace: self)
        
        pomodoro.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }.store(in: &cancellable)
        
        timeTracker.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }.store(in: &cancellable)
        
        radio.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }.store(in: &cancellable)
        
        launcher.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }.store(in: &cancellable)
        
        blocker.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }.store(in: &cancellable)
    }
    
    var cancellable = Set<AnyCancellable>()

    // MARK: Tab states
    
    @Published var pomodoro: PomodoroState
    @Published var timeTracker: TimeTrackerState
    @Published var radio: RadioState
    @Published var launcher: LauncherState
    @Published var blocker: BlockerState
    
    // MARK: Tab
    
    @Published var workspaceTab: WorkspaceTab = .pomodoro {
        didSet {
            guard workspaceTab.hasBottomMenuTool()  else {
                return
            }
            
            bottomMenuTab = workspaceTab
        }
    }
    
    @Published var bottomMenuTab: WorkspaceTab = .pomodoro
    
}




















//
//// First ViewModel
//class FirstViewModel: ObservableObject {
//    var facadeViewModel: FacadeViewModels
//
//    facadeViewModel.firstViewModelUpdateSecondViewModel()
//}
//
//// Second ViewModel
//class SecondViewModel: ObservableObject {
//
//}
//
//// FacadeViewModels Combine Both
//
//import Combine // so you can update thru nested Observable Objects
//
//class FacadeViewModels: ObservableObject {
//    lazy var firstViewModel: FirstViewModel = FirstViewModel(facadeViewModel: self)
//    @Published var secondViewModel = secondViewModel()
//}
//
//    var anyCancellable = Set<AnyCancellable>()
//
//    init() {
//        firstViewModel.objectWillChange.sink {
//                    self.objectWillChange.send()
//                }.store(in: &anyCancellable)
//
//        secondViewModel.objectWillChange.sink {
//                    self.objectWillChange.send()
//                }.store(in: &anyCancellable)
//    }
//
//    func firstViewModelUpdateSecondViewModel() {
//        //Change something on secondViewModel
//        secondViewModel
//    }
//}
