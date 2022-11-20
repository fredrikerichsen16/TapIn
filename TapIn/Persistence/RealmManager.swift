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
//                let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//                self.realm = try Realm(configuration: config)
                self.realm = try Realm()
            }
        }
        catch
        {
            fatalError(error.localizedDescription)
        }
    }
    
    func addData() {
        try! realm.write {
            realm.deleteAll()

            let workNames = ["University", "Coding"]

            let folder = FolderDB(name: "Working")

            realm.add(folder)

            for name in workNames
            {
                let ws = WorkspaceDB(name: name)
                ws.launcher.launcherInstances.append(LauncherInstanceDB(name: "Craft", type: .app, instantiated: true, appUrl: URL(string: "/Applications/Craft.app"), fileUrl: nil, launchDelay: 0.0, hideOnLaunch: false))

                ws.sessions.append(SessionDB(stage: .working(60)))
                ws.sessions.append(SessionDB(stage: .working(30)))

                let firstOfJan = DateComponents(calendar: Calendar.current, year: 2022, month: 1, day: 0, hour: 11, minute: 0).date!
                let dayInSeconds = 60 * 60 * 24

                for i in 0..<365 {
                    for _ in 0..<Int.random(in: 0..<6)
                    {
                        let session = SessionDB(stage: .working(25))
                            session.completedTime = Date(timeInterval: Double(dayInSeconds * i), since: firstOfJan)

                        ws.sessions.append(session)
                    }
                }

                folder.workspaces.append(ws)
            }
        }
    }
}
