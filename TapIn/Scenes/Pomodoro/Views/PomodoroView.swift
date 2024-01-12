import SwiftUI
import RealmSwift

struct PomodoroView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: PomodoroState {
        workspace.pomodoro
    }

    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                ProgressCircleView(circleProgress: $workspace.pomodoro.circleProgress)
                    .padding()
                
                VStack {
                    Text(vm.pomodoroStadie.getLabel())
                        .font(.body)
                    
                    Text(String(vm.remainingTimeString))
                        .font(.system(size: 36.0))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(3)
                }
            }
        }
        .onAppear {
            vm.zapTicker()
        }
    }
}
