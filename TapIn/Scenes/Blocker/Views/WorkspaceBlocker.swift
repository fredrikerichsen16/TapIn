//
//  WorkspaceBlocker.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 26/06/2021.
//

//import RealmSwift
import SwiftUI

struct WorkspaceBlocker: View {
    @EnvironmentObject var blockerModel: BlockerModel
    @State private var addWebsiteFieldValue = ""
    
    var body: some View {
        VStack {
            Text("Blocked Websites").font(.subheadline)
            
            List {
                ForEach(blockerModel.blocker.blacklistedWebsites, id: \.self) { website in
                    Text(website)
                }
            }
            
            TextField("Add Website", text: $addWebsiteFieldValue)
            Button("Add", action: {
                blockerModel.addBlacklistedWebsite(url: addWebsiteFieldValue)
            })
        }
    }
}

//struct WorkspaceBlocker_Previews: PreviewProvider {
//    static var previews: some View {
//        let workspace = WorkspaceDB(name: "Coding")
//        workspace.blocker!.blacklistedWebsites.append("facebook.com")
//        let blocker = BlockerVM(workspace)
//        return WorkspaceBlocker().environmentObject(blocker)
//    }
//}
