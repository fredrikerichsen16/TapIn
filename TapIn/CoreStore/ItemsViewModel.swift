//
//  ItemsViewModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import Foundation
import RealmSwift
import Combine

class WorkspacesVM: ObservableObject {
    @Published var workspaces: Results<WorkspaceDB>
    
    var notificationToken: NotificationToken? = nil
    
    init() {
        let workspacesResult = RealmManager.shared.realm.objects(WorkspaceDB.self)
        
        workspaces = workspacesResult
        
        notificationToken = workspaces.observe({ (change) in
            switch change {
                case .error(_):
                    print("Object was deleted")
                case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                    self.objectWillChange.send()
                    print(deletions, insertions, modifications)
                case .initial(_):
                    print("Initial run")
            }
        })
    }
}

//class WorkspacesViewModel: ObservableObject {
//    
//    @Published var workspaces = List<WorkspaceDB>()
//    
//    func updateItems() {
//        guard let realm = try? Realm() else { return }
//        guard let group = realm.objects(Group.self).first else { return }
//        self.items = group.items
//    }
//    
//    var notificationToken: NotificationToken? = nil
//    
//    init() {
//        guard let realm = try? Realm() else { return }
//        
//        let workspaces = realm.objects(WorkspaceDB.self)
//        
//        if workspaces.isEmpty {
//            print("EMPTY")
//        }
//        
//        self.workspaces = workspaces
//        
////        notificationToken = selectedGroup?.observe({ (changes) in
////            switch changes
////            {
////                case .error(_): break
////                case .change(_, _): self.objectWillChange.send()
////                case .deleted: self.selectedGroup = nil
////            }
////        })
//    }
//    
//    func addNewItem() {
//        if let realm = selectedGroup?.realm {
//            try? realm.write {
//                selectedGroup?.items.append(Item())
//            }
//        }
//    }
//    
//    func delete(item: Item) {
//        if let realm = item.realm {
//            try? realm.write({
//                realm.delete(item)
//            })
//        }
//    }
//    
//}


//class ItemsViewModel: ObservableObject {
//
//    @Published var items = List<Item>()
//    @Published var selectedGroup: Group? = nil
//
//    func updateItems() {
//        guard let realm = try? Realm() else { return }
//        guard let group = realm.objects(Group.self).first else { return }
//        self.items = group.items
//    }
//
//    var notificationToken: NotificationToken? = nil
//
//    init() {
//        guard let realm = try? Realm() else { return }
//
//        if let group = realm.objects(Group.self).first
//        {
//            let items: List<Item> = group.items
//            self.items = items
//            self.selectedGroup = group
//        }
//        else
//        {
//            try? realm.write({
//                let group = Group()
//                realm.add(group)
//
//                group.items.append(Item())
//                group.items.append(Item())
//                group.items.append(Item())
//
//                self.items = group.items
//                self.selectedGroup = group
//            })
//        }
//
//        notificationToken = selectedGroup?.observe({ (changes) in
//            switch changes
//            {
//                case .error(_): break
//                case .change(_, _): self.objectWillChange.send()
//                case .deleted: self.selectedGroup = nil
//            }
//        })
//    }
//
//    func addNewItem() {
//        if let realm = selectedGroup?.realm {
//            try? realm.write {
//                selectedGroup?.items.append(Item())
//            }
//        }
//    }
//
//    func delete(item: Item) {
//        if let realm = item.realm {
//            try? realm.write({
//                realm.delete(item)
//            })
//        }
//    }
//
//}
