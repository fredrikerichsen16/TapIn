import SwiftUI

struct RadioBottomMenuController: View {
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
    
    var body: some View {
        VStack {
            Text("Radio")
                .font(.body)
            
            Text(radioState.currentChannel.title)
                .font(.caption)
            
            HStack(spacing: 8) {
                Button(action: radioState.goToPrevChannel, label: {
                    Image(systemName: "arrowtriangle.left.fill")
                })

                Button(action: toggleButtonAction, label: getToggleButtonLabel)

                Button(action: radioState.goToNextChannel, label: {
                    Image(systemName: "arrowtriangle.right.fill")
                })
            }
        }
    }
}
