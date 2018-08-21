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
    
    func removeWorkout(_ workout: Workout) {
        if let index = workouts.index(of: workout) {
            workouts.remove(at: index)
        }
    }
    
    func moveWorkout(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedWorkout = workouts[fromIndex]
        
        workouts.remove(at: fromIndex)
        
        workouts.insert(movedWorkout, at: toIndex)
    }
    
}
