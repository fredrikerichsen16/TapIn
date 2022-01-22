//
//  WorkspaceBlocker.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

import SwiftUI

struct WorkspaceBlocker: View {
    @EnvironmentObject var workspace: Workspace
    
    var body: some View {
        Text("WorkspaceBlocker - Workspace: \(workspace.name)")
    }
}

//struct WorkspaceBlocker_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceBlocker()
//    }
//}
