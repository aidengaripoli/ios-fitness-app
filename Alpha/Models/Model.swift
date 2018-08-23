//
//  Model.swift
//  Alpha
//
//  Created by Aiden Garipoli on 23/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class Model {
    
    static let model = Model()
    
    var workoutStore = WorkoutStore()
    
    var exerciseStore = ExerciseStore()
    
    private init() {
        
    }
    
}
