import SwiftUI

struct RadioView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceVM
    @EnvironmentObject var radioState: RadioState

    private func getToggleButtonLabel() -> Image {
        return radioState.isActive ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
    }
    
    private func toggleButtonAction() {
        if radioState.isActive
        {
            radioState.endSession()
        }
        else
        {
            radioState.startSession()
        }
    }
    
    var playButtonDisabled: Bool {
        workspaceCoordinator.otherWorkspaceIsActive(than: workspace.workspace)
    }

    var body: some View {
        HStack(spacing: 40) {
            Image(radioState.currentChannel.getIllustrationImage(), bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 14) {
                Text(radioState.currentChannel.title)
                    .font(.title)
                    .fontWeight(.thin)

                HStack(spacing: 8) {
                    Button(action: radioState.goToPrevChannel, label: {
                        Image(systemName: "arrowtriangle.left.fill")
                    })

                    Button(action: toggleButtonAction, label: getToggleButtonLabel)
                        .disabled(playButtonDisabled)

                    Button(action: radioState.goToNextChannel, label: {
                        Image(systemName: "arrowtriangle.right.fill")
                    })
                }
            }
        }
        .padding()
    }
}
