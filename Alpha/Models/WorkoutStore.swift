//
//  WorkoutStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 15/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation

class WorkoutStore {
    
    var workouts = [Workout]()
    
    @discardableResult func createWorkout() -> Workout {
        let newWorkout = Workout()
        
        workouts.append(newWorkout)
        
        return newWorkout
    }
    
}
