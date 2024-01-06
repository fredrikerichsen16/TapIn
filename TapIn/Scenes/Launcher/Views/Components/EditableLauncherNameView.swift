import SwiftUI

struct EditableLauncherNameView: View {
    @State var name: String
    var onSubmit: (_ name: String) -> Void
    
    @State private var isEditing: Bool = false
    @State private var isHovering: Bool = false
    
    @State var preEditName = "error"
    
    var body: some View {
        if isEditing
        {
            TextField("", text: $name)
                .font(.body)
                .frame(width: 150, alignment: .center)
                .onSubmit {
                    isEditing = false
                    
                    guard name.count > 0 else {
                        name = preEditName
                        return
                    }
                    
                    onSubmit(name)
                }
                .onAppear {
                    preEditName = name
                }
        }
        else
        {
            HStack(spacing: 6) {
                Text(name)
                    .font(.title2)
                    .offset(x: isHovering ? 0 : 10)
                
                Image(systemName: IconKeys.pencil)
                    .opacity(isHovering ? 1 : 0)
                    .fixedSize()
                    .frame(width: 14, height: 14)
            }
            .onTapGesture {
                isEditing = true
            }
            .onHover { hovering in
                isHovering = hovering
            }
            .animation(.easeIn(duration: 0.15), value: isHovering)
        }
    }
}
