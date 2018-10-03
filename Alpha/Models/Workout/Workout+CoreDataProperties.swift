//
//  Workout+CoreDataProperties.swift
//  Alpha
//
//  Created by Aiden Garipoli on 3/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//
//

import Foundation
import CoreData


extension Workout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workout> {
        return NSFetchRequest<Workout>(entityName: "Workout")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var exerciseInstances: NSSet?

}

// MARK: Generated accessors for exerciseInstances
extension Workout {

    @objc(addExerciseInstancesObject:)
    @NSManaged public func addToExerciseInstances(_ value: ExerciseInstance)

    @objc(removeExerciseInstancesObject:)
    @NSManaged public func removeFromExerciseInstances(_ value: ExerciseInstance)

    @objc(addExerciseInstances:)
    @NSManaged public func addToExerciseInstances(_ values: NSSet)

    @objc(removeExerciseInstances:)
    @NSManaged public func removeFromExerciseInstances(_ values: NSSet)

}
