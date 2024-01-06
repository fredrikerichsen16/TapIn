import Foundation
import RealmSwift
import Factory

class FolderState: ObservableObject {
    @Injected(\.realmManager) var realmManager: RealmManager
    
    var folder: FolderDB
    
    init(folder: FolderDB) {
        self.folder = folder
        self.formInputs = FormInputs(folder: folder)
    }
    
    @Published var formInputs: FormInputs
    
    func onSubmit() {
        try? realmManager.realm.write {
            folder.updateSettings(with: formInputs)
        }
    }
}
