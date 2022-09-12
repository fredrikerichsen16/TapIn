import SwiftUI

struct MusicPlayerView: View {
    @EnvironmentObject var stateManager: StateManager
    @State var playing: Bool = false
    
    func getPlayingStatusIcon() -> Image {
        return playing
            ? Image(systemName: "pause.fill")
            : Image(systemName: "play.fill")
    }
    
    func startPlayer() {
        stateManager.startPlayer()
    }
    
    func pausePlayer() {
        stateManager.pausePlayer()
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(stateManager.selectedRadioChannel.label)
                .font(.subheadline)
            
            Button(action: {
                playing = false
                stateManager.goToPrevChannel()
            }, label: {
                Image(systemName: "arrowtriangle.left.fill")
            })
            
            Button(action: {
                playing.toggle()
                
                if playing {
                    startPlayer()
                } else {
                    pausePlayer()
                }
            }, label: {
                getPlayingStatusIcon()
            })
            
            Button(action: {
                playing = false
                stateManager.goToNextChannel()
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

