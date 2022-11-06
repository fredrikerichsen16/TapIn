import SwiftUI

extension View {
    func userPreferenceColorScheme() -> some View {
        modifier(UserPreferenceColorScheme())
    }
}

struct UserPreferenceColorScheme: ViewModifier {
    @AppStorage("colorScheme") private var colorScheme = "dark"
    
    func body(content: Content) -> some View {
        if colorScheme == "system" {
            content
        } else {
            content
                .environment(\.colorScheme, colorScheme == "dark" ? .dark : .light)
        }
    }
}
