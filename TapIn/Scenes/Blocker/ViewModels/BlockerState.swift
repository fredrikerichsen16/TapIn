import Foundation
import RealmSwift

struct BlacklistedWebsite: Identifiable {
    let id: Int
    let url: String
}

class BlockerState: ObservableObject {
    private var realm: Realm {
        RealmManager.shared.realm
    }

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
    
    func addBlacklistedWebsite(url: String) {
        guard let blocker = blocker.thaw() else { return }
        
        let url = url.lowercased().trim()
        
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
