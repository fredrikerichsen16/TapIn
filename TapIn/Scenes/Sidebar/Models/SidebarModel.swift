import SwiftUI
import RealmSwift

///
struct SidebarModel {
    /// Static links to pages (in contrast with dynamic outline)
    var pageLinks = [MenuItem.home, MenuItem.statistics]
    
    /// The user's folders and workspaces, put into a data structure that can be nested in an OutlineGroup
    var outline = [OutlineNode]()
    
    /// The currently selected menu item in the sidebar
    var selection: MenuItem? = nil
    
    /// Set the outline property on initialization of the view and after any potential updates
    mutating func setOutline(with folders: Results<FolderDB>) {
        let folders = Array(folders)
        let menuItems = folders.map({ folder in
            OutlineNode(folder: folder, children: folder.workspaces.map({ workspace in
                OutlineNode(workspace: workspace)
            }))
        })
        
        self.outline = menuItems
    }
}
