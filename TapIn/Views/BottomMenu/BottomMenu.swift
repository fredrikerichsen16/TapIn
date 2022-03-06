//
//  BottomMenu.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 21/01/2022.
//

import SwiftUI
import RealmSwift

struct BottomMenu: View {
    @ObservedRealmObject var launcher: LauncherDB
    
    @State private var showingPopover = false
    @State private var first = true
    @State private var second = false
    @State private var third = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button("Open All") {
                launcher.openAll()
            }
            
            Button("Start") {
                showingPopover.toggle()
            }
            .buttonStyle(FilledButton())
            .popover(isPresented: $showingPopover) {
                ToggleComponentMenu()
            }
        }
        .padding()
        .background(Color(r: 37, g: 37, b: 42, opacity: 1))
    }
}

struct ToggleComponentMenu: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            ToggleComponentMenuItem(iconSize: 30.0, title: "Pomodoro")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Timetracker")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Website Blocker")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Radio")
            ToggleComponentMenuItem(iconSize: 30.0, title: "All")
        }
        .padding(14)
    }
}

struct ToggleComponentMenuItem: View {
    let iconSize: Double
    let title: String
    
    @State private var active = false
    
    func getTitle() -> String {
        let prefix = active ? "Stop" : "Start"
        return "\(prefix) \(title)"
    }
    
    var body: some View {
        Button(action: {
            active.toggle()
        }, label: {
            HStack(spacing: 5.0) {
                Image(systemName: active ? "pause.fill" : "play.fill")
                    .frame(width: iconSize, height: iconSize, alignment: .center)
                    .clipShape(Circle())
                    .background(Color.blue)
                    .cornerRadius(iconSize / 2)
                    .padding(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                
                Text(getTitle())
                    .font(.system(size: 18.0))
            }
        })
        .buttonStyle(PlainButtonStyle())
        .padding(5)
    }
}

//.popover(isPresented: $showingPopover) {
//    Toggle(isOn: $first) {
//        Text("Enable Timetracking")
//    }.padding()
//
//    Toggle(isOn: $second) {
//        Text("Enable Website Blocker")
//    }.padding()
//
//    Toggle(isOn: $third) {
//        Text("Run Launcher on Start")
//    }.padding()
//
//    Button("Start Pomodoro") {
//        print("Start Pomodoro")
//    }
//
//    Button("Start Timetracker") {
//        print("Start Timetracker")
//    }
//
//    Button("Start Website Blocker") {
//        print("Start Website Blocker")
//    }
//
//    Button("Automatically Run Launcher") {
//        print("Automatically Run Launcher")
//    }
//}

//struct ContentView: View {
//    @State private var showingPopover = false
//
//    var body: some View {
//        Button("Show Menu") {
//            showingPopover = true
//        }
//        .popover(isPresented: $showingPopover) {
//            Text("Your content here")
//                .font(.headline)
//                .padding()
//        }
//    }
//}
