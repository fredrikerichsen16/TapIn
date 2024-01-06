import SwiftUI

struct SongInfoPopoverView: View {
    let song: RadioSong
    
    @State private var voteStatus = VoteStatus.neutral
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(song.title, systemImage: IconKeys.musicNote)
            Label(song.singers.joined(separator: ", "), systemImage: "person")
            
            Spacer().frame(height: 10)
            
            HStack(spacing: 6) {
                VoteButton(icon: IconKeys.thumbsUp, size: 24, buttonEffect: .upvote, voteStatus: $voteStatus)
                VoteButton(icon: IconKeys.thumbsDown, size: 24, buttonEffect: .downvote, voteStatus: $voteStatus)
            }
        }
        .padding()
    }
}
