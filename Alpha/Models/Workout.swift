//
//  Workout.swift
//  Alpha
//
//  Created by Aiden Garipoli on 15/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class Workout: NSObject {
    
    var name: String = ""
    let dateCreated: Date
    var exercises = [Exercise]()
    
    override init() {
        self.dateCreated = Date()
    }
    
//    func setExercises(exercises: [Exercise]) {
//        clearExercises()
//
//        for exercise in exercises {
//            self.exercises.append(exercise)
//        }
//    }
//
//    func clearExercises() {
//        self.exercises = []
//    }
}
