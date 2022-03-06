import SwiftUI
import RealmSwift

struct WebsiteLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    @Environment(\.realm) var realm
    
    @State var websiteName: String = ""
    @State var websiteURL: String = ""
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    showingSheet = true
                }
                .sheet(isPresented: $showingSheet, onDismiss: {
                    print("Dismissed")
                }, content: {
                    if #available(macOS 12.0, *) {
                        HStack {
                            TextField("Website Name", text: $websiteName)
                                .textFieldStyle(.squareBorder)
                            TextField("Website URL", text: $websiteURL)
                                .textFieldStyle(.roundedBorder)
                        }
                    } else {
                        Text("Unavailable")
                    }
                    
                    Button("Submit") {
                        guard let url = URL(string: websiteURL) else { return }
                        
                        if let thawed = launcherInstance.thaw() {
                            try! realm.write {
                                thawed.name = websiteName
                                thawed.filePath = websiteURL
                                
                                print("Thawed AppPath:")
                                print(thawed.filePath)
                            }
                        }
                        showingSheet = false
                    }
                })
            
            Text(launcherInstance.name).font(.title2)
            
            Button("Open") {
                launcherInstance.opener.openApp()
            }
        }
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
