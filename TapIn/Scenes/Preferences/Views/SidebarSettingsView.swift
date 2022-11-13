import SwiftUI
import UserNotifications

struct SidebarSettingsView: View {
    @StateObject var vm = TheVM()
    
    var body: some View {
        NavigationView {
//            Text("Have a settings view for deleting sidebar items, moving them, etc. so I don't have to do so much work in sidebar")
            
            List(vm.menuItems, id: \.id) { item in
                NavigationLink(destination: {
                    Text(item.label)
                    Button("Delete") {
                        vm.delete(folder: item.folder!)
                    }
                }, label: {
                    Label(item.folder!.name, image: item.icon)
                })
                .tag(item.id)
//                .contextMenu {
//                    vm.delete(folder: item.folder!)
//                }
            }
            
            Button("Add") {
                vm.addFolder()
            }
        }
    }
}

//struct SidebarSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarSettingsView()
//    }
//}

import Foundation
import RealmSwift

class TheVM: ObservableObject {
    // MARK: Normal
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        let folders = realm.objects(FolderDB.self)
        self.folders = folders
        self.menuItems = folders.map({ SidebarListItem.folder($0) })
        self.setToken()
    }
    
    // MARK: Sidebar
    
    @Published var folders: Results<FolderDB>
    @Published var menuItems: [SidebarListItem]
    
    // MARK: Token
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = folders.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(let folders, deletions: _, insertions: _, modifications: _):
                menuItems = folders.map({ SidebarListItem.folder($0) })
                self.objectWillChange.send()
            default:
                break
            }
        })
    }

    // MARK: CRUD
    
    func addFolder() {
        try? realm.write {
            let folder = FolderDB(name: "New Folder")
            realm.add(folder)
        }
    }
    
    func delete(workspace: WorkspaceDB) {
        guard let folder = workspace.folder.first?.thaw() else {
            return
        }

        try? realm.write {
            guard let workspaceIndex = folder.workspaces.firstIndex(of: workspace) else {
                return
            }

            folder.workspaces.remove(at: workspaceIndex)
            realm.delete(workspace)
        }
    }

    func delete(folder: FolderDB) {
        guard let folder = folder.thaw() else {
            return
        }

        try? realm.write
        {
            folder.workspaces.removeAll()
            realm.delete(folder)
        }
    }
}
