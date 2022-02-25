//
//  WorkspaceBlocker.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import RealmSwift

struct WorkspaceBlocker: View {
    @ObservedRealmObject var blocker: BlockerDB
    
    var body: some View {
        Text("WorkspaceBlocker - Workspace: \(blocker.workspace.first!.name)")
    }
}

struct WorkspaceBlocker_Previews: PreviewProvider {
//    let workspace: WorkspaceDB
//
//    init() {
////        let config = Realm.Configuration(inMemoryIdentifier: "PreviewRealm")
////        let realm = try! Realm(configuration: config)
//
//        let workspace = WorkspaceDB(name: "Calculus", isWork: true)
//
////        realm.add(blocker)
//
//        self.workspace = workspace
//    }

    static var previews: some View {
        WorkspaceBlocker(blocker: BlockerDB())
    }
}
