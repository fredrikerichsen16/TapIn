import Foundation
import RealmSwift

struct BlacklistedWebsite: Identifiable {
    let id: Int
    let url: String
}

class BlockerState: ObservableObject {
    var realm: Realm

    var token: NotificationToken?
    
    @Published var blocker: BlockerDB
    @Published var blacklist: [BlacklistedWebsite] = []
    
    func updateBlacklist() {
        var blacklist = [BlacklistedWebsite]()
        
        for (idx, url) in blocker.blacklistedWebsites.enumerated()
        {
            blacklist.append(BlacklistedWebsite(id: idx, url: url))
        }
        
        self.blacklist = blacklist
    }
    
    init(workspace: WorkspaceDB) {
        self.blocker = workspace.blocker
        self.realm = RealmManager.shared.realm
        self.updateBlacklist()

        self.token = blocker.observe({ [weak self] (changes) in
            switch changes
            {
            case .error(let error):
                print("Error 138490324")
                fatalError(error.localizedDescription)
            case .change(_, _):
                self?.updateBlacklist()
                self?.objectWillChange.send()
            case .deleted:
                print("Error 1894324")
                fatalError("Not possible to delete")
            }
        })
    }

//    func validateUrl(url: String) -> Bool {
//        let url = URL(string: url)
//        return url != nil
//    }

    func validateUrl(url: String) -> Bool {
        // try? NSRegularExpression(pattern: "https?:\\/\\/([\\w_-]+(?:(?:\\.[\\w_-]+)+))([\\w.,@?^=%&:\\/~+#-]*[\\w@?^=%&\\/~+#-])")

        guard let linkRegex = try? NSRegularExpression(pattern: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$", options: .caseInsensitive) else { return false }
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
        
        // Turn set into array and sort it in descending order, so that removing one doesn't shift index and affect others
        let ids = Array(ids).sorted(by: >)
        
        guard let blocker = blocker.thaw() else { return }
        
        try? realm.write {
            for id in ids {
                blocker.blacklistedWebsites.remove(at: id)
            }
        }
    }
}
