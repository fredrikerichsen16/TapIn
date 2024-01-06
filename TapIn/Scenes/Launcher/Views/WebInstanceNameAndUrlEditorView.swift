import SwiftUI

struct WebInstanceNameAndUrlEditorView: View {
    @State var instance: any WebBasedBehavior & BaseLauncherInstanceBehavior
    
    @State private var name = ""
    @State private var url = ""
    @State private var error: Swift.Error? = nil
    
    var body: some View {
        Form {
            HStack(alignment: .center, spacing: 4) {
                VStack(alignment: .leading) {
                    Text("Name")
                        .offset(x: 9)
                    
                    TextField("", text: $name)
                }

                VStack(alignment: .leading) {
                    Text("URL")
                        .offset(x: 9)
                    
                    TextField("", text: $url)
                }
            }
            .frame(minWidth: 150, idealWidth: 350, maxWidth: 350)
        }
        .onSubmit {
            do
            {
                try instance.setUrl(urlString: url)
                instance.setName(name: name)
            }
            catch
            {
                if let error = error as? BlockerError
                {
                    self.error = error
                }
            }
        }
        .onAppear {
            name = instance.name
            if let fileUrl = instance.object.fileUrl {
                url = fileUrl.absoluteString
            }
        }
        .errorAlert(error: $error)
    }
}
