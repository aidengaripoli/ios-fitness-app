//
//  WorkoutViewModel.swift
//  Alpha
//
//  Created by Aiden Garipoli on 7/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation

class WorkoutViewModel {
    
    // MARK
    
    let workout: Workout
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK
    
    init(withWorkout workout: Workout) {
        self.workout = workout
    }
    
    // MARK
    
    func formattedDate() -> String {
        return dateFormatter.string(from: workout.dateCreated! as Date)
    }
    
    func exerciseInstanceCount() -> Int {
        return workout.exerciseInstances!.count
    }
    
    func exerciseInstancesArray() -> [ExerciseInstance] {
        return workout.exerciseInstances?.allObjects as! [ExerciseInstance]
    }
}
