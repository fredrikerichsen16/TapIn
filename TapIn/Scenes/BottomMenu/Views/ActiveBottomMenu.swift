import SwiftUI
import RealmSwift

struct ActiveBottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceState

    var body: some View {
        HStack(alignment: .center) {
            navigateButton(.left)
            
            Spacer()

            switch workspace.bottomMenuTab
            {
            case .pomodoro:
                PomodoroBottomMenuController()
                    .padding()
            case .launcher:
                LauncherBottomMenuController()
                    .padding()
            case .blocker:
                BlockerBottomMenuController()
                    .padding()
            case .radio:
                RadioBottomMenuController()
            default:
                EmptyView()
            }
            
            Spacer()
            
            navigateButton(.right)
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func navigateButton(_ direction: Direction) -> some View {
        if direction == .left
        {
            Button(action: { workspace.bottomMenuTab.previous() }, label: {
                Image(systemName: IconKeys.left)
            })
        }
        else
        {
            Button(action: { workspace.bottomMenuTab.next() }, label: {
                Image(systemName: IconKeys.right)
            })
        }
    }
}

       
