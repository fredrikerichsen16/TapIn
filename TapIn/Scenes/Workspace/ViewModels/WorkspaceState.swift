import Foundation
import Combine
import Factory

fileprivate struct WorkspaceComponentFactory {
    let workspace: WorkspaceDB
    let componentsStatus: ComponentsStatus
    
    func createPomodoroState() -> PomodoroState {
        return PomodoroState(workspace: workspace)
    }
    
    func createRadioState() -> RadioState {
        return RadioState(workspace: workspace)
    }
    
    func createLauncherState() -> LauncherState {
        return LauncherState(workspace: workspace)
    }
    
    func createBlockerState() -> BlockerState {
        return BlockerState(workspace: workspace, componentsStatus: componentsStatus)
    }
}

class WorkspaceState: ObservableObject {
    @Injected(Container.realm) private var realm
    
    static var preview: WorkspaceState = {
        let realm = Container.realm.callAsFunction()
        let workspace = realm.objects(WorkspaceDB.self).first!
        let workspaceState = WorkspaceState(workspace: workspace)
        
        workspaceState.pomodoro.realm = realm
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
        self.workspaceTab = UserDefaultsManager.standard.getLatestTab(for: workspace) ?? .pomodoro
        
        let componentsStatus = ComponentsStatus()
        let factory = WorkspaceComponentFactory(workspace: workspace, componentsStatus: componentsStatus)
        
        self.pomodoro = factory.createPomodoroState()
        self.radio = factory.createRadioState()
        self.launcher = factory.createLauncherState()
        self.blocker = factory.createBlockerState()
        
        self.componentActivityTracker = ComponentActivityTracker(workspace: self, componentsStatus: componentsStatus)
        
        pomodoro.objectWillChange.sink { [weak self] (_) in
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

    // MARK: Component states
    
    @Published var pomodoro: PomodoroState
    @Published var radio: RadioState
    @Published var launcher: LauncherState
    @Published var blocker: BlockerState
    
    // MARK: Tab
    
    @Published var workspaceTab: WorkspaceTab {
        didSet {
            UserDefaultsManager.standard.setLatestTab(for: workspace, tab: workspaceTab)
            
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
