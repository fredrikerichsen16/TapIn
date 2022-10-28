//
//  PomodoroDB.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 03/02/2022.
//

import Foundation
import RealmSwift

final class PomodoroDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var pomodoroDuration: TimeInterval = 60.0 * 25.0
    
    @Persisted
    var shortBreakDuration: TimeInterval = 60.0 * 5.0
    
    @Persisted
    var longBreakDuration: TimeInterval = 60.0 * 15.0
    
    @Persisted
    var longBreakFrequency: Int8 = 3
    
    @Persisted(originProperty: "pomodoro")
    var workspace: LinkingObjects<WorkspaceDB>
}
