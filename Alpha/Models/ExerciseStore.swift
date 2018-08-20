//
//  ExerciseStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 19/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class ExerciseStore {
    
    var exercises: [Exercise]
    
    init() {
        exercises = [
            Exercise(name: "Bench Press", muscles: [.chest, .shoulders]),
            Exercise(name: "Pull Up", muscles: [.lats, .biceps]),
            Exercise(name: "Dip", muscles: [.chest, .triceps, .shoulders]),
            Exercise(name: "Push Up", muscles: [.chest, .shoulders, .triceps]),
            Exercise(name: "Bodyweight Row", muscles: [.lats])
        ]
    }
    
}
