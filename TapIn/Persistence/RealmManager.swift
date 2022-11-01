import Foundation
import RealmSwift

class RealmManager {
    public static let shared = RealmManager(preview: false)
    public static let preview = RealmManager(preview: true)
    
    private(set) var realm: Realm
    
    init(preview: Bool = false) {
        do
        {
            if preview
            {
                let config = Realm.Configuration(inMemoryIdentifier: "preview")
                self.realm = try Realm(configuration: config)
                addData()
            }
            else
            {
                let config = Realm.Configuration(schemaVersion: 7)
                self.realm = try Realm(configuration: config)
//                addData()
            }
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
