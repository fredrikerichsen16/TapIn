//
//  PomodoroModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI
import Combine

enum TimerMode {
    case initial
    case running
    case paused
}

struct PomodoroModel {
    
    var pomodoroDuration: TimeInterval = 60.0 * 3.0
    var shortBreakDuration: TimeInterval = 60.0 * 5.0
    var longBreakDuration: TimeInterval = 60.0 * 15.0
    var longBreakFrequency: Int = 3
    
    var timeElapsed: TimeInterval = 0.0
    
    var timerMode: TimerMode = .initial
    
    func getButtonTitle() -> String {
        return timerMode == .running ? "Pause" : "Start"
    }
    
    func remainingTime(_ keyPath: KeyPath<PomodoroModel, TimeInterval>) -> Double {
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
    
    func readableTime(_ keyPath: KeyPath<PomodoroModel, TimeInterval>) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
    
        return formatter.string(from: self[keyPath: keyPath]) ?? "00:00"
    }
    
}
