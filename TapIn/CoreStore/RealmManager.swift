//
//  RealmManager.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 27/01/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    public static let shared = RealmManager()
    
    private(set) var realm: Realm
    
    init() {
        do {
            let config = Realm.Configuration(schemaVersion: 6)
            
            self.realm = try Realm(configuration: config)
            
//            addData()
        }
        catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func addData() {
        try! realm.write {
            for workspace in realm.objects(WorkspaceDB.self) {
                print("Deleting: ")
                print(workspace.name)
                realm.delete(workspace)
            }
            
            let workNames = ["University", "Coding"]
            
            for name in workNames {
                let ws = WorkspaceDB(name: name)
                
                ws.launcher!.launcherInstances.append(LauncherInstanceDB(name: "Craft", type: .app, instantiated: true, appPath: "/Applications/Craft.app", filePath: nil, launchDelay: 0.0, hideOnLaunch: false))
                
                realm.add(ws)
            }
        }
    }
}
