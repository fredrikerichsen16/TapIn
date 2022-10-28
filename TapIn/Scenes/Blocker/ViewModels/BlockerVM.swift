//
//  BlockerVM.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 16/09/2022.
//

import Foundation
import RealmSwift

class BlockerVM: ObservableObject {
    var realm: Realm
//    var token: NotificationToken?
    
    @Published var blocker: BlockerDB
    
    init(_ realm: Realm, workspace: WorkspaceDB) {
        guard let blocker = workspace.blocker else {
            fatalError("Blocker should always be in database. Will probably make that non-optional eventually.")
        }
        
        self.realm = realm
        self.blocker = blocker
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

//    func addBlacklistedWebsite(url: String) {
//        blocker.addBlacklistedWebsite(realm, url: url)
//    }
}
