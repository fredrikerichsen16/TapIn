//
//  PomodoroModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

struct PomodoroModel {
	
    var pomodoroDuration: TimeInterval = 60.0 * 25.0
    var shortBreakDuration: TimeInterval = 60.0 * 5.0
    var longBreakDuration: TimeInterval = 60.0 * 15.0
    var longBreakFrequency: Int = 3
	
}
