import Foundation
import RealmSwift

class BlockerState: ObservableObject {
//    var realm: Realm {
//        RealmManager.shared.realm
//    }

    var token: NotificationToken?
    
    @Published var blocker: BlockerDB
    
    init(workspace: WorkspaceDB, stateManager: StateManager) {
//        self.workspace = workspace
//        self.stateManager = stateManager
        self.blocker = workspace.blocker

        self.token = blocker.observe({ [weak self] (changes) in
            switch changes
            {
            case .error(let error):
                print("Error 138490324")
                fatalError(error.localizedDescription)
            case .change(_, _):
                self?.objectWillChange.send()
            case .deleted:
                print("Error 1894324")
                fatalError("Not possible to delete")
            }
        })
    }
    
    func addBlacklistedWebsite(_ realm: Realm, url: String) {
        guard let blocker = blocker.thaw() else { return }
        
        try? realm.write {
            blocker.blacklistedWebsites.append(url)
        }
    }
}
