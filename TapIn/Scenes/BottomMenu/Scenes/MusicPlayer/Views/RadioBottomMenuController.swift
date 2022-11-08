import SwiftUI

struct RadioBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
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
    
    var body: some View {
        VStack {
            Text("Radio")
                .font(.body)
            
            Text(workspace.radio.currentChannel.title)
                .font(.caption)
            
            HStack(spacing: 8) {
                Button(action: workspace.radio.goToPrevChannel, label: {
                    Image(systemName: IconKeys.leftFilled)
                })

                Button(action: toggleButtonAction, label: getToggleButtonLabel)

                Button(action: workspace.radio.goToNextChannel, label: {
                    Image(systemName: IconKeys.rightFilled)
                })
            }
        }
    }
}
