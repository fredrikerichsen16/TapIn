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

// errorAlert

extension View {
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion
    }

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
