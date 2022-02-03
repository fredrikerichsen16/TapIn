//
//  BlockerDB.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 03/02/2022.
//

import Foundation
import RealmSwift

final class BlockerDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var blacklistedWebsites = RealmSwift.List<String>()
    
    @Persisted
    var whitelistedWebsites = RealmSwift.List<String>()
    
    @Persisted(originProperty: "blocker")
    var workspace: LinkingObjects<WorkspaceDB>
}

