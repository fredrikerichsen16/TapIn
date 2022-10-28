import RealmSwift
import SwiftUI

protocol WorkspaceSubcomponentStateObject: ObservableObject {
    init(workspace: WorkspaceDB, stateManager: StateManager)
    
    var realm: Realm { get set }
    var workspace: WorkspaceDB { get set }
    var stateManager: StateManager { get set }
    
    func isActive() -> Bool
}
