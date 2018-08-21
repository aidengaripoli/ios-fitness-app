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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let exercise = workout.exercises[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
}
