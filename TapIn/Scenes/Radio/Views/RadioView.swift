import SwiftUI

struct RadioView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceVM

    private func getToggleButtonLabel() -> Image {
        return workspace.radio.isActive ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
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
            Image(workspace.radio.currentChannel.getIllustrationImage(), bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 14) {
                Text(workspace.radio.currentChannel.title)
                    .font(.title)
                    .fontWeight(.thin)

                HStack(spacing: 8) {
                    Button(action: workspace.radio.goToPrevChannel, label: {
                        Image(systemName: "arrowtriangle.left.fill")
                    })

                    Button(action: toggleButtonAction, label: getToggleButtonLabel)
                        .disabled(playButtonDisabled)

                    Button(action: workspace.radio.goToNextChannel, label: {
                        Image(systemName: "arrowtriangle.right.fill")
                    })
                }
            }
        }
        .padding()
    }
}
