import SwiftUI

struct RadioView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: RadioState {
        workspace.radio
    }

    private func getToggleButtonLabel() -> Image {
        return workspace.radio.isActive ? Image(systemName: IconKeys.pauseButton) : Image(systemName: IconKeys.playButton)
    }
    
    private func toggleButtonAction() {
        if workspace.radio.isActive
        {
            workspace.radio.endSession()
        }
        else
        {
            workspace.radio.startSession()
        }
    }
    
    var playButtonDisabled: Bool {
        workspaceCoordinator.otherWorkspaceIsActive(than: workspace.workspace)
    }

    var body: some View {
        HStack(spacing: 40) {
            Image(vm.currentChannel.getIllustrationImage(), bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 14) {
                Text(vm.currentChannel.title)
                    .font(.title)
                    .fontWeight(.thin)

                HStack(spacing: 8) {
                    Button(action: vm.goToPrevChannel, label: {
                        Image(systemName: IconKeys.leftFilled)
                    })

                    Button(action: toggleButtonAction, label: getToggleButtonLabel)
                        .disabled(playButtonDisabled)

                    Button(action: vm.goToNextChannel, label: {
                        Image(systemName: IconKeys.rightFilled)
                    })
                }
            }
        }
        .padding()
    }
}

//struct RadioView_Preview: PreviewProvider {
//    static var previews: some View {
//        let workspace = WorkspaceState.preview
//
//        RadioView()
//            .environmentObject(workspace)
//            .environment(\.workspaceCoordinator, WorkspaceCoordinator.shared)
//    }
//}
