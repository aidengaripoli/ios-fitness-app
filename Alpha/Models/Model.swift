//
//  Model.swift
//  Alpha
//
//  Created by Aiden Garipoli on 23/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class Model {
    
    static let shared = Model()
    
    var workoutStore = WorkoutStore()
    
    var exerciseStore = ExerciseStore()
    
    private init() {}
    
    func createNewWorkout() -> Workout {
        let workout = Workout()
        
        return workout
    }
    
    func saveNewWorkout(workout: Workout) {
        workoutStore.workouts.append(workout)
    }
    
}
