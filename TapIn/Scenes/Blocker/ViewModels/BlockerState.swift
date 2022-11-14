import Foundation
import RealmSwift

class BlockerState: WorkspaceComponentViewModel {
    @Published var blocker: BlockerDB
    @Published var blacklist: [BlacklistedWebsite] = []
    @Published var error: Swift.Error? = nil

    init(workspace: WorkspaceDB) {
        self.blocker = workspace.blocker
        super.init(workspace: workspace, realm: RealmManager.shared.realm, tab: .blocker)
        setToken()
    }
    
    // MARK: Token/Fetching/Setting blocklist model array
    
    var token: NotificationToken? = nil
    
    func setToken() {
        self.token = blocker.blacklistedWebsites.observe({ [weak self] (changes) in
            switch changes
            {
            case .update(_, deletions: _, insertions: _, modifications: _):
                self?.fetch()
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

    func validateUrl(url: String) -> Bool {
        guard let linkRegex = try? NSRegularExpression(pattern: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$") else { return false }
        return linkRegex.firstMatch(in: url, options: [], range: NSRange(location: 0, length: url.count)) != nil
    }

    func addBlacklistedWebsite(url: String) {
        guard let blocker = blocker.thaw() else { return }

        let url = url.lowercased().trim()

        guard validateUrl(url: url) else { return }

        try? realm.write {
            blocker.blacklistedWebsites.append(url)
        }
    }

    func deleteBlacklistedWebsite(by ids: Set<Int>) {
        if ids.isEmpty {
            return
        }

        guard let blocker = blocker.thaw() else { return }

        try? realm.write {
            blocker.blacklistedWebsites.remove(atOffsets: IndexSet(ids))
        }
    }
    
    // MARK: Start and end session
    
    override func startSession() {
        super.startSession()
        
        ContentBlocker.shared.setBlacklist(Array(blocker.blacklistedWebsites))
        ContentBlocker.shared.start()
    }

    override func endSession() {
        super.endSession()
        
        ContentBlocker.shared.stop()
    }
    
    func requestEndSession() {
        if blocker.blockerStrength == .lenient {
            endSession()
        } else {
            error = BlockerError.blockerStrengthStrict
        }
    }
    
    func stopBlocker() {
        ContentBlocker.shared.stop()
    }
}
