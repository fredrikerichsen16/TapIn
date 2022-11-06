import SwiftUI

struct EditableLauncherNameView: View {
    @State var name: String
    var onSubmit: (_ name: String) -> Void
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        if isEditing
        {
            TextField("", text: $name)
                .font(.body)
                .frame(width: 150, alignment: .center)
                .onSubmit {
                    isEditing = false
                    onSubmit(name)
                }
        }
        else
        {
            Text(name).font(.title2)
                .onTapGesture(count: 2) {
                    isEditing = true
                }
        }
    }
}
