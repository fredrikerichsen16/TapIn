//
//  WorkspacePomodoro.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

struct WorkspacePomodoro: View {
    @EnvironmentObject var workspace: Workspace
    
    var timeString: String {
        let remainingTime = workspace.pomodoro.remainingTime(\.pomodoroDuration)
        return workspace.pomodoro.readableTime(seconds: remainingTime)
    }
    
    @State var circleProgress = 1.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
		Spacer()
        
        ZStack {
            ProgressCircleView(circleProgress: $circleProgress)
                .padding()
                .onReceive(timer) { time in
                    let pomodoroDuration = workspace.pomodoro.pomodoroDuration
                    let timeElapsed = workspace.pomodoro.timeElapsed
                    
                    self.circleProgress = (pomodoroDuration - timeElapsed) / pomodoroDuration
                }
            
            VStack {
                Text(timeString)
                    .font(.system(size: 36.0))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
                    .onReceive(timer) { time in
                        guard workspace.pomodoro.timerMode == .running else { return }
                        
                        workspace.pomodoro.timeElapsed += 1
                    }
                
                Button("Fetch") {
                    workspace.pomodoro.startFetch()
                }
                
                Text(workspace.pomodoro.time)
            }
        }
        
//        Spacer()
//        
//        HStack(spacing: 10) {
//            Button(workspace.pomodoro.getButtonTitle()) {
//                if workspace.pomodoro.timerMode == .running {
//                    workspace.pomodoro.timerMode = .paused
//                } else {
//                    workspace.pomodoro.timerMode = .running
//                }
//            }
//            .buttonStyle(FilledButton())
//
//            Button("Cancel") {
//                workspace.pomodoro.timeElapsed = 0.0
//                workspace.pomodoro.timerMode = .initial
//            }
//            .buttonStyle(FilledButton())
//            .disabled(workspace.pomodoro.timerMode != .paused)
//        }
//
//        Spacer()
//            .frame(height: 10)
    }
}

struct ProgressCircleView: View {

    @EnvironmentObject var workspace: Workspace

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
                .rotationEffect(.degrees(0))//270.0))
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
