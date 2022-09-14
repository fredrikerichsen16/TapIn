import SwiftUI

struct MusicPlayerView: View {
    @EnvironmentObject var stateManager: StateManager
    
    private func getPlayingStatusIcon() -> Image {
        return stateManager.radioIsPlaying
            ? Image(systemName: "pause.fill")
            : Image(systemName: "play.fill")
    }
    
    private func startPlayer() {
        stateManager.radioManager.play()
    }
    
    private func pausePlayer() {
        stateManager.radioManager.pause()
    }
    
    private func prevChannel() {
        stateManager.radioManager.goToPrevChannel()
    }
    
    private func nextChannel() {
        stateManager.radioManager.goToNextChannel()
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(stateManager.radioManager.getActiveChannel().label)
                .font(.subheadline)
            
            Button(action: {
                prevChannel()
            }, label: {
                Image(systemName: "arrowtriangle.left.fill")
            })
            
            Button(action: {
                stateManager.radioIsPlaying.toggle()
                
                if stateManager.radioIsPlaying {
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

//struct MusicPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}

