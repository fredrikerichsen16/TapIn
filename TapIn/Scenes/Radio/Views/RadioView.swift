import SwiftUI

//struct RadioView: View {
//    var body: some View {
//        Text("Radio")
//    }
//}

struct RadioView: View {
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
        HStack(spacing: 40) {
            Image(radioState.getActiveChannel().image, bundle: .main)
                .resizable()
                .scaledToFit()
                .frame(height: 340)
                .cornerRadius(15)

            VStack(alignment: .leading, spacing: 14) {
                Text(radioState.getActiveChannel().label)
                    .font(.title)
                    .fontWeight(.thin)

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
        .padding()
    }
}
