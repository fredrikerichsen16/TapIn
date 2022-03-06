import SwiftUI
import RealmSwift

struct WorkspaceLauncher: View {
	@State private var showingSheet = false
	@State private var showingPopover = false
	@State private var appSelection: Int? = nil
    @State private var selectedInstance: ObjectId? = nil
    
    @ObservedRealmObject var launcher: LauncherDB
    @Environment(\.realm) var realm
	
    var body: some View {
		VStack(alignment: .leading) {
			Spacer().frame(height: 25)

			NavigationView {
                VStack(alignment: .leading) {
                    List(launcher.launcherInstances, id: \.id, selection: $selectedInstance) { instance in
                        launcherInstanceMenuButton(instance: instance)
                    }
                    .frame(width: 210, alignment: .center)

                    HStack(alignment: .center, spacing: 5) {
                        Button(action: {
                            showingPopover.toggle()
                        }, label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16.0))
                        })
                        .buttonStyle(PlainButtonStyle())
                        .popover(isPresented: $showingPopover) {
                            Popover(launcher: launcher, selection: $appSelection, showingPopover: $showingPopover)
                        }

                        Button(action: {
                            guard let deleteId = selectedInstance else { return }
                            guard let instanceToDelete = realm.objects(LauncherInstanceDB.self).where({ ($0.id == deleteId) }).first else { return }

                            if let thawed = instanceToDelete.thaw() {
                                try! realm.write {
                                    realm.delete(thawed)
                                }
                            }
                            
                            // launcher.deleteById(id: deleteId)
                        }, label: {
                            Image(systemName: "minus")
                                .font(.system(size: 16.0))
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()

                Text("Select one...").font(.title2)
			}

			Spacer()
		}
    }
    
    @ViewBuilder
    func navigationLinkDestination(instance: LauncherInstanceDB) -> some View {
        switch instance.fullType {
            case .app:
                AppLauncherView(launcherInstance: instance)
            case .file:
                FileLauncherView(launcherInstance: instance)
            case .folder:
                FileLauncherView(launcherInstance: instance)
            case .website:
                WebsiteLauncherView(launcherInstance: instance)
            case .empty(_):
                EmptyLauncherView(launcherInstance: instance)
            default:
                Text("DEFAULT: \(instance.name)")
        }
    }
    
    @ViewBuilder
    func launcherInstanceMenuButton(instance: LauncherInstanceDB) -> some View {
        NavigationLink(destination: navigationLinkDestination(instance: instance)) {
            HStack {
                Image(nsImage: instance.appController.iconForApp(size: 34))
                
                Text(instance.name)
                
                Spacer()
            }
            .tag(instance.id.stringValue)
            .onTapGesture(count: 2) {
                instance.opener.openApp()
            }
        }
    }
}

//struct WorkspaceLauncher_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceLauncher()
//    }
//}
