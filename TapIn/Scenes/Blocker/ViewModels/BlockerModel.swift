//
//  BlockerModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import Foundation
import RealmSwift

class BlockerModel: ObservableObject {
//    var realm: Realm {
//        RealmManager.shared.realm
//    }

//    var token: NotificationToken?
    
    @Published var blocker: BlockerDB
    
    init(_ workspaceVM: WorkspaceVM) {
        self.blocker = workspaceVM.workspace.blocker

//        self.token = blocker.observe({ [weak self] (changes) in
//            switch changes
//            {
//            case .error(let error):
//                print("Error 138490324")
//                fatalError(error.localizedDescription)
//            case .change(_, _):
//                self?.objectWillChange.send()
//            case .deleted:
//                print("Error 1894324")
//                fatalError("Not possible to delete")
//            }
//        })
    }
    
    func addBlacklistedWebsite(_ realm: Realm, url: String) {
        try? realm.write {
            blocker.blacklistedWebsites.append(url)
        }
    }

//    func addBlacklistedWebsite(url: String) {
//        blocker.addBlacklistedWebsite(realm, url: url)
//    }
}
