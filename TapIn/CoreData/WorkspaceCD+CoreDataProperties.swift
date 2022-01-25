//
//  WorkspaceCD+CoreDataProperties.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//
//

import Foundation
import CoreData


extension WorkspaceCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkspaceCD> {
        return NSFetchRequest<WorkspaceCD>(entityName: "WorkspaceCD")
    }

    @NSManaged public var isWork: Bool
    @NSManaged public var name: String?
    @NSManaged public var children: NSOrderedSet?
    @NSManaged public var parent: WorkspaceCD?

}

// MARK: Generated accessors for children
extension WorkspaceCD {

    @objc(insertObject:inChildrenAtIndex:)
    @NSManaged public func insertIntoChildren(_ value: WorkspaceCD, at idx: Int)

    @objc(removeObjectFromChildrenAtIndex:)
    @NSManaged public func removeFromChildren(at idx: Int)

    @objc(insertChildren:atIndexes:)
    @NSManaged public func insertIntoChildren(_ values: [WorkspaceCD], at indexes: NSIndexSet)

    @objc(removeChildrenAtIndexes:)
    @NSManaged public func removeFromChildren(at indexes: NSIndexSet)

    @objc(replaceObjectInChildrenAtIndex:withObject:)
    @NSManaged public func replaceChildren(at idx: Int, with value: WorkspaceCD)

    @objc(replaceChildrenAtIndexes:withChildren:)
    @NSManaged public func replaceChildren(at indexes: NSIndexSet, with values: [WorkspaceCD])

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: WorkspaceCD)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: WorkspaceCD)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSOrderedSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSOrderedSet)

}

extension WorkspaceCD : Identifiable {

}
