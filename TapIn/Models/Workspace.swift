//
//  Workspace.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 04/08/2021.
//

import SwiftUI

class Workspace: Identifiable {
    
    @State var isExpanded: Bool = true
    
    var uuid: UUID = UUID()
    var name: String
    var work: Bool
    var children: [Workspace] = []
    var parent: Workspace?
    
    init(name: String, parent: Workspace) {
        self.name = name
        self.work = parent.work
        self.parent = parent
    }
    
    init(name: String, work: Bool = true, children: [Workspace] = []) {
        self.name = name
        self.work = work
        self.children = children
    }
    
    func addChild(name: String) {
        let child = Workspace(name: name, parent: self)
        
        children.append(child)
    }
    
    var pomodoro: PomodoroModel = PomodoroModel()
    var timeTracker: TimeTrackerModel = TimeTrackerModel()
    var launcher: LauncherModel = LauncherModel()
    var blocker: BlockerModel = BlockerModel()
    
    var hasChildren: Bool {
        return children.count > 0
    }
    
    func getChildrenMenuItems() -> [MenuItem] {
        var menuItems = [MenuItem]()
        
        for workspace in children
        {
            menuItems.append(MenuItem.init(workspace: workspace, work: work))
        }
        
        return menuItems
    }
    
}
