//
//  ExerciseInstance.swift
//  Alpha
//
//  Created by Aiden Garipoli on 25/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class ExerciseInstance: NSObject {
    
    let exercise: Exercise
    
    var sets = [(weight: Int, reps: Int)]()
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.sets.append((weight: 0, reps: 0)) // default set
    }
    
}
