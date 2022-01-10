//
//  TopLevelNavigationItem.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 04/01/2022.
//

//import SwiftUI
//
//struct TopLevelMenuItem: View {
//    @EnvironmentObject var workspaces: Workspaces
//    @State var workspaceItem: MenuItem
//    @Binding var isExpanded = false
//    
//    var body: some View {
//        DisclosureGroup(isExpanded: $isExpanded, content: {
//            ForEach(workspaceItem.getChildrenMenuItems, id: \.id) { child in
//                navigationLink(child)
//            }
//        }, label: {
//            navigationLink(workspaceItem)
//        })
//    }
//    
//    @ViewBuilder
//    private func viewForMenuItem(_ item: MenuItem) -> some View {
//        switch item
//        {
//        case .home:
//            Text("Home").font(.largeTitle)
//        case .statistics:
//            Text("Statistics").font(.largeTitle)
//        case .work(let ws):
//            WorkspaceBrowse().onAppear {
//                workspaces.activeWorkspace = ws
//            }
//        case .leisure(let ws):
//            WorkspaceBrowse().onAppear {
//                workspaces.activeWorkspace = ws
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private func navigationLink(_ item: MenuItem) -> some View {
//        NavigationLink(destination: viewForMenuItem(item)) {
//            Label(item.text, systemImage: item.icon)
//                .tag(item.id)
//                .padding(.vertical, 5)
//        }
//        .contextMenu(ContextMenu(menuItems: {
//            menuItemContextMenu(item.workspace)
//        }))
//    }
//    
//    @ViewBuilder
//    private func menuItemContextMenu(_ ws: Workspace?) -> some View {
//        if let ws = ws
//        {
//            Group {
//                Button("Delete") {
//                    print("Delete")
//                }
//                
//                Button("Add Child") {
//                    print("Add Child")
//                }
//                
//                Button("Rename") {
//                    print("Rename")
//                }
//            }
//        }
//        else
//        {
//            Group {
//                Button("Delete") {
//                    print("Delete")
//                }
//
//                Button("Rename") {
//                    print("Rename")
//                }
//            }
//        }
//    }
//}
//
//
//struct TopLevelMenuItem_Preview: PreviewProvider {
//    static var previews: some View {
//        TopLevelMenuItem()
//    }
//}
