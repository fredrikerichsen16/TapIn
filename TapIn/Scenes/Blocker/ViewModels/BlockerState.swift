import Foundation
import RealmSwift

class BlockerState: WorkspaceComponentViewModel {
    
    // MARK: Properties
    
    var blocker: BlockerDB
    
    @Published var blacklist: [BlacklistedWebsite] = []
    
    @Published var addWebsiteFieldValue = ""
    @Published var tableSelection: Set<Int> = Set()
    @Published var error: Swift.Error? = nil
    
    // MARK: Init

    init(workspace: WorkspaceDB) {
        self.blocker = workspace.blocker
        super.init(workspace: workspace, realm: RealmManager.shared.realm, component: .blocker)
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

        try? realm.write {
            blocker.blacklistedWebsites.append(url)
        }
        
        addWebsiteFieldValue = ""
    }
    
    func delete() {
        if tableSelection.isEmpty {
            return
        }

        guard let blocker = blocker.thaw() else { return }

        try? realm.write {
            blocker.blacklistedWebsites.remove(atOffsets: IndexSet(tableSelection))
        }
        
        tableSelection = Set()
    }

    private func validateUrl(url: String) -> Bool {
        guard let linkRegex = try? NSRegularExpression(pattern: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$") else { return false }
        return linkRegex.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.count)) != nil
    }
    
    // MARK: Start and end session
    
    override func startSession() {
        super.startSession()
        
        ContentBlocker.shared.start(withBlacklist: Array(blocker.blacklistedWebsites))
    }

    override func endSession() {
        super.endSession()
        
        ContentBlocker.shared.stop()
    }
    
    func requestEndSession(sessionIsInProgress: Bool) {
        if blocker.blockerStrength == .lenient || sessionIsInProgress == false {
            endSession()
        } else {
            error = BlockerError.blockerStrengthStrict
        }
    }
}
