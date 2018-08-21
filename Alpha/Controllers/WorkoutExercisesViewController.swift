//
//  WorkoutExercisesController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 16/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class WorkoutExercisesViewController: UITableViewController {
    
    // MARK: - Properties
    
    var workout: Workout! {
        didSet {
            navigationItem.title = workout.name
        }
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(workout.name)
        
        for ex in workout.exercises {
            print(ex.name)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - TableView
    
    
    
}
