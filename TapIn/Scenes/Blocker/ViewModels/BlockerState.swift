import Foundation
import RealmSwift
import Factory

class BlockerState: WorkspaceComponentViewModel {
    @Injected(\.realmManager) var realmManager: RealmManager
    
    // MARK: Properties
    
    var blocker: BlockerDB
    var componentsStatus: ComponentsStatus
    
    @Published var blacklist: [BlacklistedWebsite] = []
    
    @Published var addWebsiteFieldValue = ""
    @Published var tableSelection: Set<Int> = Set()
    @Published var error: Swift.Error? = nil
    
    // MARK: Init

    init(workspace: WorkspaceDB, componentsStatus: ComponentsStatus) {
        let realm = Container.shared.realmManager.callAsFunction().realm
        self.blocker = workspace.blocker
        self.componentsStatus = componentsStatus
        super.init(workspace: workspace, realm: realm, component: .blocker)
        setToken()
    }
    
    // MARK: Token/Fetching/Setting blocklist model array
    
    var token: NotificationToken? = nil
    
    private func setToken() {
        self.token = blocker.blacklistedWebsites.observe({ [unowned self] (changes) in
            switch changes
            {
            case .initial(_):
                self.fetch()
            case .update(_, deletions: _, insertions: _, modifications: _):
                self.fetch()
            default:
                break
            }
        })
    }
    
    func fetch() {
        var blacklist = [BlacklistedWebsite]()

        for (idx, url) in blocker.blacklistedWebsites.enumerated()
        {
            blacklist.append(BlacklistedWebsite(id: idx, url: url))
        }

        self.blacklist = blacklist
    }
    
    // MARK: CRUD
    
    func add() {
        let url = addWebsiteFieldValue.lowercased().trim()
        
        guard !url.isEmpty else {
            return
        }

        guard validateUrl(url: url) else {
            error = BlockerError.invalidUrl
            return
        }
        
        guard let blocker = blocker.thaw() else { return }

        try? realmManager.realm.write {
            blocker.blacklistedWebsites.append(url)
        }
        
        addWebsiteFieldValue = ""
    }
    
    func delete() {
        if tableSelection.isEmpty {
            return
        }

        guard let blocker = blocker.thaw() else { return }

        try? realmManager.realm.write {
            blocker.blacklistedWebsites.remove(atOffsets: IndexSet(tableSelection))
        }
        
        tableSelection = Set()
    }

    private func validateUrl(url: String) -> Bool {
        guard let linkRegex = try? NSRegularExpression(pattern: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$") else { return false }
        return linkRegex.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.count)) != nil
    }
    
    // MARK: Start and end session
    
    var terminateAtDate: Date? = nil
    
    override func startSession() {
        super.startSession()
        
        terminateAtDate = nil
        
        if componentsStatus.isActive(.pomodoro) && blocker.blockerStrength == .extreme
        {
            let pomodoroDurationInSeconds = Double(workspace.pomodoro.pomodoroDuration * 60)
            terminateAtDate = Date(timeIntervalSinceNow: pomodoroDurationInSeconds)
        }
        
        ContentBlocker.shared.config(blacklist: Array(blocker.blacklistedWebsites), terminateAtDate: terminateAtDate)
        ContentBlocker.shared.start()
    }

    override func endSession() {
        guard isActive else {
            return
        }
        
        let pomodoroIsActive = componentsStatus.isActive(.pomodoro)
        
        if blocker.blockerStrength == .extreme, let date = terminateAtDate, date > Date.now
        {
            error = BlockerError.extremeStrictnessError(date)
            return
        }
        else if blocker.blockerStrength == .normal && pomodoroIsActive
        {
            error = BlockerError.normalStrictnessError
            return
        }
        
        isActive = false
        sendStatusChangeNotification(status: false)
        
        ContentBlocker.shared.stop()
    }
}
