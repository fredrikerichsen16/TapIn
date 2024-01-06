import Foundation
import RealmSwift
import Factory

class FolderState: ObservableObject {
    @Injected(Container.realm) private var realm
    
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
