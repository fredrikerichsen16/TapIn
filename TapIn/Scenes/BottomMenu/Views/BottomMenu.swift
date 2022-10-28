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

    var body: some View {
        VStack {
            Text("Pomodoro").font(.body)
            pomodoroState.getButtons()
        }
    }
}

enum BottomMenuControllerSelection {
    case pomodoro
    case launcher
    case blocker
    
    mutating func next() {
        switch self
        {
        case .pomodoro:
            self = .launcher
        case .launcher:
            self = .blocker
        case .blocker:
            self = .pomodoro
        }
    }
    
    mutating func previous() {
        switch self
        {
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
    @Environment(\.realm) var realm // just passing through
    @ObservedRealmObject var workspace: WorkspaceDB // just passing through
    @StateObject var pomodoroState: PomodoroState // just passing through
    
    @EnvironmentObject var stateManager: StateManager
    @Binding var bottomMenuControllerSelection: BottomMenuControllerSelection
    
    var body: some View {
        HStack {
            MusicPlayerView(radioState: stateManager.getRadioState(realm: realm, workspace: workspace))
            
            Spacer()
            
            Group {
                navigateButton(direction: .left)
                
                switch bottomMenuControllerSelection
                {
                case .pomodoro:
                    PomodoroBottomMenuController(pomodoroState: pomodoroState)
                        .padding()
                case .launcher:
                    LauncherBottomMenuController(launcher: workspace.launcher!)
                        .padding()
                case .blocker:
                    BlockerBottomMenuController()
                        .padding()
                }
                navigateButton(direction: .right)
            }
        }
        .padding(EdgeInsets.init(top: 2, leading: 22, bottom: 2, trailing: 22))
        .background(Color(r: 37, g: 37, b: 42, opacity: 1))
    }
    
    private func navigateButton(direction: Direction) -> some View {
        var action: () -> Void = {}
        var icon: String = ""
        
        if direction == .right
        {
            action = { bottomMenuControllerSelection.next() }
            icon = "chevron.right"
        }
        else
        {
            action = { bottomMenuControllerSelection.previous() }
            icon = "chevron.left"
        }
        
        return Button(action: action, label: {
            Image(systemName: icon)
        }).buttonStyle(PlainButtonStyle())
    }
}
