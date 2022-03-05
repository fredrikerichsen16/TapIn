//
//  WorkspaceDB.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 27/01/2022.
//

import Foundation
import RealmSwift

final class WorkspaceDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var name: String = "New Workspace"
    
    @Persisted
    var isWork: Bool = true
    
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
        
    convenience init(name: String, isWork: Bool) {
        self.init()
        self.id = ObjectId.generate()
        self.name = name
        self.isWork = isWork
        
        self.pomodoro = PomodoroDB()
        self.blocker = BlockerDB()
        self.timeTracker = TimeTrackerDB()
        self.launcher = LauncherDB()
    }
    
    func isChild() -> Bool {
        return !parent.isEmpty
    }
    
    static func getWorkspacesByWorkType(realm: Realm, isWork: Bool) -> Results<WorkspaceDB> {
        let workspaces = realm.objects(WorkspaceDB.self)
        let workspacesToShow = workspaces.where {
            ($0.isWork == isWork) && ($0.parent.count == 0)
        }
        
        return workspacesToShow
    }
    
//    func getChildrenMenuItems() -> [MenuItem] {
//        var menuItems = [MenuItem]()
//        
//        for workspace in children
//        {
//            menuItems.append(MenuItem.init(workspace: workspace, work: isWork))
//        }
//        
//        return menuItems
//    }
}

//final class Group: Object, ObjectKeyIdentifiable {
//
//    @objc dynamic var _id = ObjectId.generate()
//
//    @objc dynamic var name: String = "new"
//
//    override class func primaryKey() -> String? {
//        return "_id"
//    }
//
//    var items = RealmSwift.List<Item>()
//
//}
