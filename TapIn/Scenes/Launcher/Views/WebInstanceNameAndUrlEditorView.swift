import SwiftUI

struct WebInstanceNameAndUrlEditorView: View {
    @State var instance: any WebBasedBehavior & BaseLauncherInstanceBehavior
    
    @State private var name = ""
    @State private var url = ""
    
    var body: some View {
        Form {
            TextField("Name", text: $name)
            TextField("URL", text: $url)
        }
        .onSubmit {
            instance.setName(name: name)
            instance.setUrl(urlString: url)
        }
        .onAppear {
            name = instance.name
            if let fileUrl = instance.object.fileUrl {
                url = fileUrl.absoluteString
            }
        }
    }
}
