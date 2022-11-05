import Foundation
import Combine

class ComponentActivityTracker {
    let componentDidChangeActivityStatus: NSNotification.Name = NSNotification.Name("ComponentDidChangeActivityStatus")
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    
    let workspace: WorkspaceVM
    
    init(workspace: WorkspaceVM) {
        self.workspace = workspace
        
        // Observing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pomodoroComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.pomodoro)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(timeTrackerComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.timeTracker)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(radioComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.radio)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(blockerComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.blocker)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var activeComponents: Set<WorkspaceTab> = Set()
    
    private func getStatus(from notification: Notification) -> TimerMode? {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return nil
        }
        
        return userInfo["status"] as? TimerMode
    }
    
    private func forNowAllOfThemHaveTheSameImplementation(notification: Notification, tab: WorkspaceTab) {
        guard let status = getStatus(from: notification) else {
            return
        }
        
        if status.isActive()
        {
            activeComponents.insert(tab)
            
            coordinator.setActive(workspace: workspace)
        }
        else
        {
            activeComponents.remove(tab)
            
            if activeComponents.isEmpty
            {
                coordinator.disactivate()
            }
        }
        
        print(activeComponents)
    }
    
    @objc func pomodoroComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .pomodoro)
    }
    
    @objc func timeTrackerComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .timetracking)
    }
    
    @objc func radioComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .radio)
    }
    
    @objc func blockerComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .blocker)
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
