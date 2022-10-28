import Foundation
import RealmSwift

fileprivate func getRealmConfig() -> Realm.Configuration {
    return Realm.Configuration(schemaVersion: 7)
}

class RealmManager {
    public static let shared = RealmManager()
    
    private(set) var realm: Realm
    
    init() {
        do
        {
            let config = getRealmConfig()
            self.realm = try Realm(configuration: config)
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    func addData() {
        try! realm.write {
            for workspace in realm.objects(WorkspaceDB.self)
            {
                print("Deleting: ")
                print(workspace.name)
                realm.delete(workspace)
            }
            
            let workNames = ["University", "Coding"]
            
            for name in workNames
            {
                let ws = WorkspaceDB(name: name)
                
                ws.launcher.launcherInstances.append(LauncherInstanceDB(name: "Craft", type: .app, instantiated: true, appUrl: URL(string: "/Applications/Craft.app"), fileUrl: nil, launchDelay: 0.0, hideOnLaunch: false))
                
                realm.add(ws)
            }
        }
    }
}
