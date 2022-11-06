import SwiftUI
import RealmSwift

struct SidebarModel {
    /// Static links to pages (in contrast with dynamic outline)
    var pageLinks = [SidebarListItem.home, SidebarListItem.statistics]
    
    /// The user's folders and workspaces, put into a data structure that can be nested in an OutlineGroup
    var outline = [OutlineNode]()
    
    /// The currently selected menu item in the sidebar
    var selection: SidebarListItem? = nil
    
    /// Set the outline property on initialization of the view and after any potential updates
    mutating func setOutline(with folders: Results<FolderDB>) {
        let folders = Array(folders)
        let outlineNodes = folders.map({ folder in
            OutlineNode(folder: folder, children: folder.workspaces.map({ workspace in
                OutlineNode(workspace: workspace)
            }))
        })
        
        self.outline = outlineNodes
    }
}
