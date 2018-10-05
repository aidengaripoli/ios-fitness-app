//
//  ExerciseInstance+CoreDataProperties.swift
//  Alpha
//
//  Created by Aiden Garipoli on 5/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseInstance {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseInstance> {
        return NSFetchRequest<ExerciseInstance>(entityName: "ExerciseInstance")
    }

    @NSManaged public var exercise: Exercise?
    @NSManaged public var sets: NSSet?
    @NSManaged public var workout: Workout?

}

// MARK: Generated accessors for sets
extension ExerciseInstance {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: ExerciseSet)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: ExerciseSet)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}
