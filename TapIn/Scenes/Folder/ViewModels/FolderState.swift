import Foundation
import RealmSwift

class FolderState: ObservableObject {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    var folder: FolderDB
    
    init(folder: FolderDB) {
        self.folder = folder
        
        let formInputs = FormInputs(folder: folder)
        self.originalFormInputs = formInputs
        self.formInputs = formInputs
    }
    
    let originalFormInputs: FormInputs
    
    @Published var formInputs: FormInputs
    
    func onSubmit() {
        try? realm.write {
            folder.updateSettings(with: formInputs)
        }
    }
}
