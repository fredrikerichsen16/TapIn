//
//  TimeTrackerDB.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 03/02/2022.
//

import Foundation
import RealmSwift

final class TimeTrackerDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var trackPomodoroTime: Bool = true
    
    @Persisted(originProperty: "timeTracker")
    var workspace: LinkingObjects<WorkspaceDB>
}
