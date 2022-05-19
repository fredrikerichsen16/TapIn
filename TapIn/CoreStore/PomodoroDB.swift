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
    
    var timeElapsed: TimeInterval = 0.0
    
    var timerMode: TimerMode = .initial
    
    func getButtonTitle() -> String {
        return timerMode == .running ? "Pause" : "Start"
    }
    
    func remainingTime(_ keyPath: KeyPath<PomodoroDB, TimeInterval>) -> Double {
        let startTime = self[keyPath: keyPath]
        
        return startTime - timeElapsed
    }
    
    func readableTime(seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: seconds) ?? "FAIL"
    }
    
    func readableTime(_ keyPath: KeyPath<PomodoroDB, TimeInterval>) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
    
        return formatter.string(from: self[keyPath: keyPath]) ?? "00:00"
    }
}
