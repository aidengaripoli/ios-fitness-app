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

    func createNewWorkout() -> Workout {
        let workout = Workout()
        
        return workout
    }
    
    func createNewWorkout(date: Date) -> Workout {
        let workout = Workout(date: date)
        
        return workout
    }
    
    func saveNewWorkout(workout: Workout) {
         workouts.append(workout)
    }
    
    // MARK: - Temporary Testing Methods
    
    func createDummyWorkouts(amount: Int) {
        for i in 0...amount {
            let newWorkout: Workout
            
            if i % 2 == 0 {
                newWorkout = createNewWorkout(date: Date(timeIntervalSinceNow: TimeInterval(-691200)))
            } else {
                newWorkout = createNewWorkout()
            }
            
            newWorkout.name = "Workout #\(i)"
            newWorkout.exerciseInstances.append(
                ExerciseInstance(exercise: Model.shared.exerciseStore.exercises[0])
            )
            
            saveNewWorkout(workout: newWorkout)
        }
    }
    
}
