import SwiftUI
import RealmSwift

func convertURL(urlString: String) -> String? {
    var str = urlString.lowercased().trim()
    
    if !(str.starts(with: "https://") || str.starts(with: "http://")) {
        str = "https://" + str
    }
    
        let regex = "^(https?:\\/\\/)?([\\da-z\\.-]+\\.[a-z\\.]{2,6}|[\\d\\.]+)([\\/:?=&#]{1}[\\da-z\\.-]+)*[\\/\\?]?$"
    // adding [c] after the comparator (MATCHES) makes it case insensitive
    let predicate = NSPredicate(format:"SELF MATCHES[c] %@", argumentArray:[regex])
    
    if predicate.evaluate(with: str) == false {
        return nil
    }
    
    if URL(string: str) == nil {
        return nil
    }
    
    return str
}

struct WebsiteLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    @Environment(\.realm) var realm
    
    @State var showingSheet = false
    
    var body: some View {
        VStack {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    showingSheet = true
                }
                .sheet(isPresented: $showingSheet) {
                    WebsiteEditSheetView(launcherInstance: launcherInstance)
                }
            
            Text(launcherInstance.name).font(.title2)
        }
    }
}

struct WebsiteEditSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    
    @State private var websiteName: String = ""
    @State private var websiteURL: String = ""
    
    var body: some View {
        Section {
            if #available(macOS 12.0, *)
            {
                VStack(alignment: .center, spacing: 5) {
                    Text("Website Name").font(.body)
                    TextField("", text: $websiteName)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Website URL").font(.body)
                    TextField("", text: $websiteURL)
                        .textFieldStyle(.roundedBorder)
                }
            }
            else
            {
                Text("Unavailable")
            }
            
            HStack(alignment: .center, spacing: 5) {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                Button(action: onSubmitSheet, label: { Text("Submit") })
            }
        }.padding(15)
    }
    
    func onSubmitSheet() {
        guard let cleanWebsiteUrl = convertURL(urlString: websiteURL) else { return }
        launcherInstance.fileController.setFile(name: websiteName, filePath: cleanWebsiteUrl)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
