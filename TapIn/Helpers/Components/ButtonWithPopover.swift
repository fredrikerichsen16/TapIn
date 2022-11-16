import SwiftUI

struct ButtonWithPopover<Content>: View where Content: View {
    let popover: Content
    let buttonTitle: String
    let buttonAction: () -> Void
    
    @State var nameField: String = ""
    @State var isRenaming = false
    
    init(buttonTitle: String, buttonAction: @escaping () -> Void, @ViewBuilder popover: () -> Content) {
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        self.popover = popover()
    }
    
    @State private var showingPopover = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button(buttonTitle, action: buttonAction)
            Button(action: {
                showingPopover = true
            }, label: {
                Image(systemName: "chevron.up")
            })
            .popover(isPresented: $showingPopover, content: {
                popover.padding()
            })
        }
    }
}


