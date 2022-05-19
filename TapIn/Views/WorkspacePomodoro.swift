//
//  WorkspacePomodoro.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI
import RealmSwift

//struct WorkspacePomodoro: View {
//    @EnvironmentObject var workspace: Workspace
//
//    var timeString: String {
//        let remainingTime = workspace.pomodoro.remainingTime(\.pomodoroDuration)
//        return workspace.pomodoro.readableTime(seconds: remainingTime)
//    }
//
//    @State var circleProgress = 1.0
//
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//
//    var body: some View {
//		Spacer()
//
//        ZStack {
//            ProgressCircleView(circleProgress: $circleProgress)
//                .padding()
//                .onReceive(timer) { time in
//                    let pomodoroDuration = workspace.pomodoro.pomodoroDuration
//                    let timeElapsed = workspace.pomodoro.timeElapsed
//
//                    self.circleProgress = (pomodoroDuration - timeElapsed) / pomodoroDuration
//                }
//
//            VStack {
//                Text(timeString)
//                    .font(.system(size: 36.0))
//                    .bold()
//                    .multilineTextAlignment(.center)
//                    .padding()
//                    .onReceive(timer) { time in
//                        guard workspace.pomodoro.timerMode == .running else { return }
//
//                        workspace.pomodoro.timeElapsed += 1
//                    }
//            }
//        }
//    }
//}

struct WorkspacePomodoro: View {
    @EnvironmentObject var stateManager: StateManager
    @StateObject var pomodoroState: PomodoroState
    
    @State var falseInitialCircleProgress = 1.0
    
    var body: some View {
        Spacer()
        
        ZStack {
            ProgressCircleView(circleProgress: $pomodoroState.circleProgress)
                .padding()
            
            VStack {
                Text(String(pomodoroState.remainingTimeString))
                    .font(.system(size: 36.0))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

struct ProgressCircleView: View {

    @Binding var circleProgress: Double

    var body: some View {
        
//        GeometryReader { proxy in
//            VStack(spacing: 15) {
//                ZStack {
//                    Circle()
//                        .trim(from: 0, to: 0.5)
//                        .stroke(Color.purple.opacity(0.7), lineWidth: 10)
//                }
//                .padding(60)
//                .frame(height: proxy.size.width)
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//        }
        
        ZStack {
            Circle()
                .stroke(lineWidth: 18.0)
                .opacity(0.08)
                .foregroundColor(.black)

            Circle()
                .trim(from: 0.0, to: CGFloat(circleProgress))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundColor(.blue)
                // .foregroundColor(getCircleColor(timerSeconds: timerSeconds))
                .animation(.linear)
        }
        .frame(width: 330, height: 330, alignment: .center)
    }
}

//struct WorkspacePomodoro_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspacePomodoro(pomodoro: PomodoroDB())
//            .environmentObject(StateManager())
//    }
//}
