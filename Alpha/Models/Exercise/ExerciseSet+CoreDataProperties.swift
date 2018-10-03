//
//  ExerciseSet+CoreDataProperties.swift
//  Alpha
//
//  Created by Aiden Garipoli on 3/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSet> {
        return NSFetchRequest<ExerciseSet>(entityName: "ExerciseSet")
    }

    @NSManaged public var reps: Int32
    @NSManaged public var weight: Int32
    @NSManaged public var exerciseInstance: ExerciseInstance?

}
