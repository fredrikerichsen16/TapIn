import RealmSwift
import SwiftUI

class MultiStateObjectHolder<T: WorkspaceSubcomponentStateObject> {
    var stateObjects: [ObjectId: T] = [:]
    
    func getObject(workspace: WorkspaceDB) -> T? {
        return stateObjects[workspace.id]
    }

    func getObject(workspace: WorkspaceDB, stateManager: StateManager) -> T {
        let workspaceId = workspace.id
        let activeWorkspace = stateManager.activeWorkspace
        
        print("GETTING OBJECT")
        
        for k in stateObjects.keys {
            print(k)
        }

        if let state = stateObjects[workspaceId]
        {
            print("Getting existing!")
            return state
        }
        else
        {
            print("Getting NON existing!")
            
            if let activeWorkspace = activeWorkspace
            {
                stateObjects = stateObjects.filter({
                    $0.value.workspace == activeWorkspace
                })
            }
            else
            {
                stateObjects = [:]
            }

            let state = T.init(workspace: workspace, stateManager: stateManager)
            stateObjects[workspaceId] = state
            
            return state
        }
    }
    
    func getActiveObject() -> T? {
        let active = stateObjects.filter({
            $0.value.isActive()
        })

        assert(active.count <= 1)

        return active.first?.value
    }
    
//    func getActiveObject(activeWorkspace: WorkspaceDB?) -> T? {
//        guard let workspace = activeWorkspace else { return nil }
//
//        let active = stateObjects.filter({
//            $0.value.workspace == workspace
//        })
//
//        assert(active.count <= 1)
//
//        return active.first?.value
//    }
}
