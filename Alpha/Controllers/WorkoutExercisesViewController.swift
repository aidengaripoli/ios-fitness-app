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
    
    var model: Model!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editExercises":
            let selectExercisesViewController = segue.destination as! SelectExerciseViewController
            selectExercisesViewController.workout = workout
            selectExercisesViewController.model = model
        case "exerciseDetail":
            if let row = tableView.indexPathForSelectedRow?.row {
                let exerciseInstanceArray = workout.exerciseInstances?.allObjects as! [ExerciseInstance]
                
                let exerciseInstance = exerciseInstanceArray[row]
                
                let exerciseDetailViewController = segue.destination as! ExerciseDetailViewController
                exerciseDetailViewController.exerciseInstance = exerciseInstance
                exerciseDetailViewController.model = model
            }
        default:
            preconditionFailure("")
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (workout.exerciseInstances?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let exerciseInstanceArray = workout.exerciseInstances?.allObjects as! [ExerciseInstance]
        
        let exercise = exerciseInstanceArray[indexPath.row].exercise
        
        cell.textLabel?.text = exercise?.name
        cell.imageView?.image = UIImage(named: exercise!.mechanics!)
        cell.detailTextLabel?.text = exercise?.mechanics!.capitalized
        
        return cell
    }
    
}
