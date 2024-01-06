import SwiftUI

struct RadioBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState

    var vm: RadioState {
        workspace.radio
    }

    private func getToggleButtonLabel() -> Image {
        return vm.isActive ? Image(systemName: IconKeys.pauseButton) : Image(systemName: IconKeys.playButton)
    }
    
    private func toggleButtonAction() {
        if vm.isActive {
            vm.endSession()
        } else {
            vm.startSession()
        }
    }
    
    var body: some View {
        VStack {
            Text("Radio")
                .font(.body)
            
            Text(vm.channelTitle)
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
