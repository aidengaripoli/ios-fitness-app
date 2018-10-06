//
//  Exercise+CoreDataProperties.swift
//  Alpha
//
//  Created by Aiden Garipoli on 6/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var exerciseID: String?
    @NSManaged public var name: String?
    @NSManaged public var mechanics: String?
    @NSManaged public var exerciseInstances: NSSet?
    @NSManaged public var muscles: NSSet?

}

// MARK: Generated accessors for exerciseInstances
extension Exercise {

    @objc(addExerciseInstancesObject:)
    @NSManaged public func addToExerciseInstances(_ value: ExerciseInstance)

    @objc(removeExerciseInstancesObject:)
    @NSManaged public func removeFromExerciseInstances(_ value: ExerciseInstance)

    @objc(addExerciseInstances:)
    @NSManaged public func addToExerciseInstances(_ values: NSSet)

    @objc(removeExerciseInstances:)
    @NSManaged public func removeFromExerciseInstances(_ values: NSSet)

}

// MARK: Generated accessors for muscles
extension Exercise {

    @objc(addMusclesObject:)
    @NSManaged public func addToMuscles(_ value: Muscle)

    @objc(removeMusclesObject:)
    @NSManaged public func removeFromMuscles(_ value: Muscle)

    @objc(addMuscles:)
    @NSManaged public func addToMuscles(_ values: NSSet)

    @objc(removeMuscles:)
    @NSManaged public func removeFromMuscles(_ values: NSSet)

}
