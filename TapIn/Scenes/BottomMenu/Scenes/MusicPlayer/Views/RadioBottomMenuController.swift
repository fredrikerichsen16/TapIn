import SwiftUI

struct RadioBottomMenuController: View {
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
    
    var body: some View {
        VStack {
            Text("Radio")
                .font(.body)
            
            Text(workspace.radio.currentChannel.title)
                .font(.caption)
            
            HStack(spacing: 8) {
                Button(action: workspace.radio.goToPrevChannel, label: {
                    Image(systemName: "arrowtriangle.left.fill")
                })

                Button(action: toggleButtonAction, label: getToggleButtonLabel)

                Button(action: workspace.radio.goToNextChannel, label: {
                    Image(systemName: "arrowtriangle.right.fill")
                })
            }
        }
    }
}
