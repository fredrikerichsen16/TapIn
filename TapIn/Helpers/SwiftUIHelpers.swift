import SwiftUI

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .font(.system(size: 20.0))
            .padding()
            .background(isEnabled ? Color.blue : .gray)
            .cornerRadius(10)
    }
}
