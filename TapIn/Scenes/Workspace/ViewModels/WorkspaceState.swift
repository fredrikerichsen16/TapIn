import Foundation
import Combine

class WorkspaceState: ObservableObject {
    static var preview: WorkspaceState = {
        let realm = RealmManager.preview.realm
        let workspace = realm.objects(WorkspaceDB.self).first!
        let workspaceState = WorkspaceState(workspace: workspace)
        
        workspaceState.pomodoro.realm = realm
        workspaceState.timeTracker.realm = realm
        workspaceState.radio.realm = realm
        workspaceState.launcher.realm = realm
        workspaceState.blocker.realm = realm
        
        return workspaceState
    }()
    
    // MARK: Init
    
    var workspace: WorkspaceDB
    var componentActivityTracker: ComponentActivityTracker!
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.workspaceTab = UserDefaultsManager.main.getLatestTab(for: workspace) ?? .pomodoro
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
    
    @Published var workspaceTab: WorkspaceTab {
        didSet {
            UserDefaultsManager.main.setLatestTab(for: workspace, tab: workspaceTab)
            
            if workspaceTab.hasBottomMenuTool() {
                bottomMenuTab = workspaceTab
            }
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
