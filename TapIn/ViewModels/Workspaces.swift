import SwiftUI
import CoreData

final class Workspaces: ObservableObject {
    
    init() {
        self.workspaces = Dataloader.getWorkspaces()
    }
    
    @Published var workspaces: [Workspace] = []
    @Published var activeWorkspace: Workspace? = nil
    
    func getTopLevelMenuItems(work: Bool) -> [MenuItem] {
        return []
//        var menuItems = [MenuItem]()
//
//        for workspace in workspaces
//        {
//            if workspace.work == work {
//                menuItems.append(MenuItem.init(workspace: workspace, work: work))
//            }
//        }
//
//        return menuItems
    }

}
