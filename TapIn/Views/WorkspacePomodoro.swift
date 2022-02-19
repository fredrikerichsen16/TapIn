//
//  WorkspacePomodoro.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

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
    @EnvironmentObject var workspaceDB: WorkspaceDB
    
    var timeString: String {
        guard let pomodoro = workspaceDB.pomodoro else { return "Pikk" }
        
        let remainingTime = pomodoro.remainingTime(\.pomodoroDuration)
        
        return pomodoro.readableTime(seconds: remainingTime)
    }
    
    @State var circleProgress = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Spacer()
        
        ZStack {
            ProgressCircleView(circleProgress: $circleProgress)
                .padding()
                .onReceive(timer) { time in
                    let pomodoroDuration = workspaceDB.pomodoro!.pomodoroDuration
                    let timeElapsed = workspaceDB.pomodoro!.timeElapsed
                    
                    self.circleProgress = (pomodoroDuration - timeElapsed) / pomodoroDuration
                }
            
            VStack {
                Text(timeString)
                    .font(.system(size: 36.0))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                    .onReceive(timer) { time in
                        guard workspaceDB.pomodoro!.timerMode == .running else { return }
                        
                        workspaceDB.pomodoro!.timeElapsed += 1
                    }
            }
        }
    }
}

struct ProgressCircleView: View {

    @Binding var circleProgress: Double

    var body: some View {
        ZStack{
            Circle()
                .stroke(lineWidth: 13.0)
                .opacity(0.08)
                .foregroundColor(.black)

            Circle()
                .trim(from: 0.0, to: CGFloat(circleProgress))
                .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270.0))
                .foregroundColor(.blue)
                // .foregroundColor(getCircleColor(timerSeconds: timerSeconds))
                .animation(.linear)
        }
        .frame(width: 330, height: 330, alignment: .center)
    }
}

//func getCircleColor(timerSeconds: Int) -> Color {
//    if (timerSeconds <= 10 && timerSeconds > 3) {
//        return Color.yellow
//    } else if (timerSeconds <= 3){
//        return Color.red
//    } else {
//        return Color.green
//    }
//}

//struct WorkspacePomodoro_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspacePomodoro(workspace: nil)
//    }
//}
