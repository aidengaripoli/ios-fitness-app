//
//  Model.swift
//  Alpha
//
//  Created by Aiden Garipoli on 23/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit
import CoreData

class Model {

    var workoutStore: WorkoutStore!

    var exerciseStore: ExerciseStore!
    
    init(workoutStore: WorkoutStore, exerciseStore: ExerciseStore) {
        self.workoutStore = workoutStore
        self.exerciseStore = exerciseStore

        self.workoutStore.fetchAllWorkouts()
    }
    
}
