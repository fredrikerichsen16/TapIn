//
//  BottomMenu.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 21/01/2022.
//

import SwiftUI

struct BottomMenu: View {
    @State private var showingPopover = false
    @State private var first = true
    @State private var second = false
    @State private var third = false
    
    var body: some View {
        HStack {
            Spacer()
            
            Button("Start") {
                showingPopover.toggle()
            }
            .buttonStyle(FilledButton())
            .popover(isPresented: $showingPopover) {
                ToggleComponentMenu()
            }
        }
        .padding()
        .background(Color.gray)
    }
}

struct ToggleComponentMenu: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0) {
            ToggleComponentMenuItem(iconSize: 30.0, title: "Start Pomodoro")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Start Timetracker")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Start Website Blocker")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Start Radio")
            ToggleComponentMenuItem(iconSize: 30.0, title: "Start All")
        }
        .padding(14)
    }
}

struct ToggleComponentMenuItem: View {
    let iconSize: Double
    let title: String
    
    var body: some View {
        Button(action: {
            print(title)
        }, label: {
            HStack(spacing: 5.0) {
                Image(systemName: "play.fill")
                    .frame(width: iconSize, height: iconSize, alignment: .center)
                    .clipShape(Circle())
                    .background(Color.blue)
                    .cornerRadius(iconSize / 2)
                    .padding(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
                
                Text(title)
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
