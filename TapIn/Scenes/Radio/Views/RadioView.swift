import SwiftUI

struct RadioView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceState
    
    @State private var showingSongInfoPopover = false
    
    var vm: RadioState {
        workspace.radio
    }

    private func getToggleButtonLabel() -> Image {
        return workspace.radio.isActive ? Image(systemName: IconKeys.pauseButton) : Image(systemName: IconKeys.playButton)
    }
    
    private func toggleButtonAction() {
        if vm.isActive {
            vm.endSession()
        } else {
            vm.startSession()
        }
    }
    
    var playButtonDisabled: Bool {
        workspaceCoordinator.otherWorkspaceIsActive(than: workspace.workspace)
    }

    var body: some View {
        HStack(spacing: 40) {
            Image(vm.radioStatus.currentChannel.getIllustrationImage(), bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 14) {
                Text(vm.channelTitle)
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
                
                HStack {
                    Label(vm.songAndArtist, systemImage: IconKeys.musicNote)
                        .underline(pattern: .dot)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .monospaced()
                }
                .frame(width: 200, alignment: .leading)
                .onTapGesture {
                    showingSongInfoPopover = true
                }
                .popover(isPresented: $showingSongInfoPopover) {
                    SongInfoPopoverView(song: vm.radioStatus.currentSong)
                }
            }
        }
        .padding()
    }
}

struct RadioView_Preview: PreviewProvider {
    static var previews: some View {
        let workspace = WorkspaceState.preview

        RadioView()
            .environmentObject(workspace)
            .environment(\.workspaceCoordinator, WorkspaceCoordinator.shared)
    }
}
