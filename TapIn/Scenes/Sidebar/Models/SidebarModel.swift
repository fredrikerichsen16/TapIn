import SwiftUI
import RealmSwift

struct SidebarModel {
    /// Static links to pages (in contrast with dynamic outline)
    var pageLinks = [SidebarListItem]()
    
    /// The user's folders and workspaces, put into a data structure that can be nested in an OutlineGroup
    var outline = [SidebarListItem]()
    
    /// The currently selected menu item in the sidebar
    var selection: String? = nil
    
    /// Set the outline property on initialization of the view and after any potential updates
    mutating func setOutline(with folders: [FolderDB]) {
        let listItems = folders.map({ folder in
            SidebarListItem(folder: folder, children: folder.workspaces.map({ workspace in
                SidebarListItem(workspace: workspace)
            }))
        })
        
        self.outline = listItems
    }
    
    mutating func update(_ listItem: SidebarListItem, name: String) {
        for (i, folder) in outline.enumerated()
        {
            if folder.id == listItem.id {
                var copy = outline[i]
                    copy.name = name
                outline[i] = copy
                
                return
            }

            if let children = folder.children
            {
                for (j, workspace) in children.enumerated()
                {
                    if workspace.id == listItem.id {
                        var copy = outline[i].children![j]
                            copy.name = name
                        outline[i].children![j] = copy
                        
                        return
                    }
                }
            }
        }
    }
    
    init() {
        self.pageLinks = [SidebarListItem(id: "statistics", name: "Statistics", icon: IconKeys.piechart)]
    }
}
