import SwiftUI
import UserNotifications
import RealmSwift

class TheVM: ObservableObject {
    init() {
        let realm = RealmManager.shared.realm
        self.folders = realm.objects(FolderDB.self)
        self.setToken()
    }
        
    @Published var folders: Results<FolderDB>
    
    // MARK: Token
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = folders.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: _, insertions: _, modifications: _):
                objectWillChange.send()
            default:
                break
            }
        })
    }
     
    func delete(folder: FolderDB) {
        let realm = RealmManager.shared.realm
        let workspaces = folder.workspaces
        do
        {
            try realm.write {
                folder.workspaces = List()
                realm.delete(workspaces)
                if let foundFolder = realm.object(ofType: FolderDB.self, forPrimaryKey: folder.id) {
                    realm.delete(foundFolder)
                }
            }
        }
        catch let error as NSError
        {
            fatalError("Error: \(error)")
        }
    }
}

struct SidebarSettingsView: View {
    @StateObject var vm = TheVM()
    
    var body: some View {
        VStack {
            Text("Have a settings view for deleting sidebar items, moving them, etc. so I don't have to do so much work in sidebar")
            List(vm.folders) { folder in
                Text(folder.name)
                Button("delete") {
                    vm.delete(folder: folder)
                }
            }
        }
    }
}

struct SidebarSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarSettingsView()
    }
}
