//
//  WorkoutStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 15/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation

class WorkoutStore {
    
    // MARK: - Stored Properties
    
    var workouts = [Workout]()
    
    // MARK: - Methods
    
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

    // MARK: - Temporary Testing Methods
    
    func createDummyWorkouts(amount: Int) {
        for i in 0...amount {
            let newWorkout: Workout
            
            if i % 2 == 0 {
                newWorkout = Workout(date: Date(timeIntervalSinceNow: TimeInterval(-691200)))
            } else {
                newWorkout = Workout()
            }
            
            newWorkout.name = "Workout #\(i)"
            newWorkout.exercises.append(
                Exercise(name: "Bench", muscles: [.chest])
            )
            
            workouts.append(newWorkout)
        }
    }
    
}
