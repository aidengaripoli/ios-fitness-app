//
//  Muscle+CoreDataProperties.swift
//  Alpha
//
//  Created by Aiden Garipoli on 3/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//
//

import Foundation
import CoreData


extension Muscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Muscle> {
        return NSFetchRequest<Muscle>(entityName: "Muscle")
    }

    @NSManaged public var name: String?
    @NSManaged public var exercise: Exercise?

}
