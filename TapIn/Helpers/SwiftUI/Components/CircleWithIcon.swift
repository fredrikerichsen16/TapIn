import SwiftUI

enum VoteStatus {
    case upvote
    case downvote
    case neutral
}

struct VoteButton: View {
    var icon: String
    var size: Double
    var buttonEffect: VoteStatus
    @Binding var voteStatus: VoteStatus
    
    @State private var isHovering = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(borderColor(), lineWidth: 1.0)
                .frame(width: size, height: size)
            Image(systemName: icon)
                .resizable()
                .frame(width: size - 12, height: size - 12)
        }
        .onHover {
            isHovering = $0
        }
        .onTapGesture {
            if buttonEffect == voteStatus {
                voteStatus = .neutral
            } else {
                voteStatus = buttonEffect
            }
        }
    }
    
    func borderColor() -> Color {
        if buttonEffect == voteStatus {
            return buttonEffect == .upvote ? Color.green : Color.red
        } else {
            return isHovering ? Color.black : Color.gray
        }
    }
}
