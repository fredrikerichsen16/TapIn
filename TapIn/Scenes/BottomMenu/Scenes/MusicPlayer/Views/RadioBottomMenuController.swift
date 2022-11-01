import SwiftUI

struct RadioBottomMenuController: View {
    @EnvironmentObject var radioState: RadioState
    
    private func getPlayingStatusIcon() -> Image {
        return radioState.radioIsPlaying
            ? Image(systemName: "pause.fill")
            : Image(systemName: "play.fill")
    }

    private func startPlayer() {
        radioState.play()
    }

    private func pausePlayer() {
        radioState.pause()
    }

    private func prevChannel() {
        radioState.goToPrevChannel()
    }

    private func nextChannel() {
        radioState.goToNextChannel()
    }
    
    var body: some View {
        VStack {
            Text("Radio")
                .font(.body)
            
            Text(radioState.getActiveChannel().label)
                .font(.caption)
            
            HStack(spacing: 8) {
                Button(action: {
                    prevChannel()
                }, label: {
                    Image(systemName: "arrowtriangle.left.fill")
                })
                
                Button(action: {
                    radioState.radioIsPlaying.toggle()
                    
                    if radioState.radioIsPlaying {
                        startPlayer()
                    } else {
                        pausePlayer()
                    }
                }, label: {
                    getPlayingStatusIcon()
                })
                
                Button(action: {
                    nextChannel()
                }, label: {
                    Image(systemName: "arrowtriangle.right.fill")
                })
            }
        }
    }
}
