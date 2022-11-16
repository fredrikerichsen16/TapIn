import Foundation
import RealmSwift

class FolderState: ObservableObject {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    var folder: FolderDB
    
    init(folder: FolderDB) {
        self.folder = folder
        self.formInputs = FormInputs(folder: folder)
    }
    
    @Published var formInputs: FormInputs
    
    func onSubmit() {
        try? realm.write {
            folder.updateSettings(with: formInputs)
        }
    }
}
