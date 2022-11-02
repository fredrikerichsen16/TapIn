import SwiftUI
import RealmSwift

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }

    }
}

struct NotesView: View {
    @ObservedRealmObject var note: NoteDB
    
    var body: some View {
        TextEditor(text: $note.contents)
            .font(.system(size: 16, design: .monospaced))
            .lineSpacing(4)
            .padding()
    }
}
