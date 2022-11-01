import SwiftUI
import RealmSwift

struct MenuItemNode: Identifiable {
    var id = UUID()
    var menuItem: MenuItem
    var children: [MenuItemNode]? = nil
    
    static func createOutline(workspaces: [WorkspaceDB]) -> [MenuItemNode] {
        var menuItemNodes: [MenuItemNode] = workspaces.map({ MenuItemNode(menuItem: .workspace($0)) })
        
        for i in 0..<menuItemNodes.count
        {
            let children = Array(workspaces[i].children)
            
            if children.count > 0 {
                menuItemNodes[i].children = children.map({ MenuItemNode(menuItem: .workspace($0)) })
            }
        }
        
        return menuItemNodes
    }
}
