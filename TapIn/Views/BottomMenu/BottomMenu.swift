//
//  BottomMenu.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 21/01/2022.
//

import SwiftUI
import RealmSwift

struct BlockerBottomMenuController: View {
    var body: some View {
        VStack {
            Text("Blocker").font(.body)
            
            Button("Start Blocker") {
                print("Activate Blocker")
            }
        }
    }
}

struct LauncherBottomMenuController: View {
    @ObservedRealmObject var launcher: LauncherDB
    
    var body: some View {
        VStack {
            Text("Launcher").font(.body)
            
            Button("Launch") {
                launcher.openAll()
            }
        }
    }
}

struct PomodoroBottomMenuController: View {
    @EnvironmentObject var stateManager: StateManager
    @StateObject var pomodoroState: PomodoroState
    @State private var displayCannotStartPomodoroError = false
    
    var vstack: some View {
        VStack {
            Text("Pomodoro").font(.body)
            
            HStack {
                switch (pomodoroState.timerMode, pomodoroState.pomodoroStage)
                {
                case (.running, .pomodoro):
                    Button("Cancel", action: pomodoroState.cancelSession)
                    Button("Pause", action: pomodoroState.pauseSession)
                case (.running, .longBreak), (.running, .shortBreak):
                    Button("Skip", action: pomodoroState.skipBreak)
                    Button("Pause", action: pomodoroState.pauseSession)
                
                case (.initial, .pomodoro):
                    Button("Start", action: startPomodoroWithCheck)
                case (.initial, .longBreak), (.initial, .shortBreak):
                    Button("Skip", action: pomodoroState.skipBreak)
                    Button("Start", action: startPomodoroWithCheck)
                
                    
                case (.paused, .pomodoro):
                    Button("Cancel", action: pomodoroState.cancelSession)
                    Button("Resume", action: pomodoroState.resumeSession)
                case (.paused, .longBreak), (.paused, .shortBreak):
                    Button("Skip", action: pomodoroState.skipBreak)
                    Button("Resume", action: pomodoroState.resumeSession)
                }
            }
        }
    }
    
    var body: some View {
        if #available(macOS 12.0, *)
        {
            vstack
                .alert("Cannot start pomodoro session because one is already active in a different workspace", isPresented: $displayCannotStartPomodoroError, actions: {})
        }
        else
        {
            vstack
        }
    }
    
    func startPomodoroWithCheck() {
        if stateManager.getActivePomodoro() != nil {
            displayCannotStartPomodoroError = true
            return
        }
        
        pomodoroState.startSession()
    }
}

enum BottomMenuControllerSelection {
    case pomodoro
    case launcher
    case blocker
    
    mutating func next() {
        switch self {
        case .pomodoro:
            self = .launcher
        case .launcher:
            self = .blocker
        case .blocker:
            self = .pomodoro
        }
    }
    
    mutating func previous() {
        switch self {
        case .pomodoro:
            self = .blocker
        case .launcher:
            self = .pomodoro
        case .blocker:
            self = .launcher
        }
    }
}

enum Direction {
    case right
    case left
}

struct BottomMenu: View {
    @ObservedRealmObject var launcher: LauncherDB // just passing through
    @StateObject var pomodoroState: PomodoroState // just passing through
    
    @EnvironmentObject var stateManager: StateManager
    
    @Binding var bottomMenuControllerSelection: BottomMenuControllerSelection
    
    var body: some View {
        HStack {
            Spacer()
            
//            Button(action: { bottomMenuControllerSelection.previous() }, label: {
//                Image(systemName: "chevron.left")
//            })
//            .buttonStyle(PlainButtonStyle())
            
            navigateButton(direction: .left)
            
            switch bottomMenuControllerSelection {
            case .pomodoro:
                PomodoroBottomMenuController(pomodoroState: pomodoroState)
                    .padding()
            case .launcher:
                LauncherBottomMenuController(launcher: launcher)
                    .padding()
            case .blocker:
                BlockerBottomMenuController()
                    .padding()
            }
            
//            Button(action: { bottomMenuControllerSelection.next() }, label: {
//                Image(systemName: "chevron.right")
//            })
//            .buttonStyle(PlainButtonStyle())
            
            navigateButton(direction: .right)
        }
        .padding(EdgeInsets.init(top: 2, leading: 22, bottom: 2, trailing: 22))
        .background(Color(r: 37, g: 37, b: 42, opacity: 1))
    }
    
    private func navigateButton(direction: Direction) -> some View {
        var action: () -> Void = {}
        var icon: String = ""
        
        if direction == .right {
            action = { bottomMenuControllerSelection.next() }
            icon = "chevron.right"
        } else {
            action = { bottomMenuControllerSelection.previous() }
            icon = "chevron.left"
        }
        
        return Button(action: action, label: {
            Image(systemName: icon)
        })
        .buttonStyle(PlainButtonStyle())
    }
}
