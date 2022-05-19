//
//  WorkspaceDB.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 27/01/2022.
//

import Foundation
import RealmSwift

final class WorkspaceDB: Object, ObjectKeyIdentifiable {
    
    func easyThaw() -> (WorkspaceDB, Realm) {
        guard let thawed = self.thaw(),
              let realm = thawed.realm else { fatalError("Easythaw failed") }
        
        return (thawed, realm)
    }
    
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var name: String = "New Workspace"
    
    @Persisted
    var children = RealmSwift.List<WorkspaceDB>()
    
    @Persisted(originProperty: "children")
    var parent: LinkingObjects<WorkspaceDB>
    
    @Persisted
    var pomodoro: PomodoroDB?
    
    @Persisted
    var blocker: BlockerDB?
    
    @Persisted
    var timeTracker: TimeTrackerDB?
    
    @Persisted
    var launcher: LauncherDB?
    
    @Persisted
    var sessions = RealmSwift.List<SessionDB>()
        
    convenience init(name: String) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        
        self.pomodoro = PomodoroDB()
        self.blocker = BlockerDB()
        self.timeTracker = TimeTrackerDB()
        self.launcher = LauncherDB()
    }
    
    func isChild() -> Bool {
        return !parent.isEmpty
    }
    
    static func getWorkspaces(realm: Realm) -> Results<WorkspaceDB> {
        let workspaces = realm.objects(WorkspaceDB.self).where { $0.parent.count == 0 }
        
        return workspaces
    }
    
    // - MARK: CRUD
    
    // MARK: Workspaces
    
    func renameWorkspace(_ realm: Realm, name: String) {
        guard let thawed = self.thaw() else { return }
        
        if name == "" { return }
                
        try! realm.write {
            thawed.name = name
        }
    }
    
    func addChild(_ realm: Realm) {
        guard let thawed = self.thaw() else { return }
        
        // You can only nest once, i.e. two levels
        if thawed.isChild() {
            print("Cannot add more than one level of nesting")
            return
        }
        
        let childWorkspace = WorkspaceDB(name: "New Workspace")
        
        try! realm.write {
            thawed.children.append(childWorkspace)
        }
    }
    
    static func deleteWorkspace(_ realm: Realm, workspace: WorkspaceDB) {
        guard let thawed = workspace.thaw() else { return }
        
        try! realm.write {
            realm.delete(thawed)
        }
    }
    
    // MARK: Sessions
    
    func getWorkDuration(dateInterval: DateInterval) -> Double {
//        let workspaces = realm.objects(WorkspaceDB.self).where { $0.parent.count == 0 }
        
        let startTime = dateInterval.start
        let endTime = dateInterval.end
        
        let sessionsInInterval = sessions.filter("completedTime BETWEEN {%@, %@}", startTime, endTime)
        
        return sessionsInInterval.sum(of: \.duration)
    }
    
//    static func deleteById(_ realm: Realm, id: ObjectId) -> Bool {
//        guard let instanceToDelete = realm.objects(LauncherInstanceDB.self).where({ ($0.id == id) }).first else {
//            // TODO: Return a double where the second element is the status where it says e.g. that no instance with that id was found
//            return true
//        }
//
//        if let thawed = instanceToDelete.thaw() {
//            try! realm.write {
//                realm.delete(thawed)
//            }
//
//            return true
//        }
//
//        return false
//    }
    
}
