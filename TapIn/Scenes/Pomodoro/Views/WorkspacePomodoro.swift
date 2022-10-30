import SwiftUI
import RealmSwift

struct WorkspacePomodoro: View {
    @StateObject var pomodoroState: PomodoroState
    
    init(_ workspaceVM: WorkspaceVM) {
        self._pomodoroState = StateObject(wrappedValue: workspaceVM.pomodoroState)
    }
    
    var body: some View {
        Spacer()
        
        ZStack {
            ProgressCircleView(circleProgress: $pomodoroState.circleProgress)
                .padding()
            
            VStack {
                Text(pomodoroState.stageState.getLabel())
                    .font(.body)
                
                Text(String(pomodoroState.remainingTimeString))
                    .font(.system(size: 36.0))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(3)
            }
        }
    }
}

struct ProgressCircleView: View {
    @Binding var circleProgress: Double

    var body: some View {
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
                .animation(.linear, value: circleProgress)
        }
        .frame(width: 330, height: 330, alignment: .center)
    }
}
