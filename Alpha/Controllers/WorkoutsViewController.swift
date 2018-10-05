//
//  WorkoutsViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 13/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class WorkoutsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var model: Model!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Actions
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addWorkout":
            let navigationController = segue.destination as! UINavigationController
            let addWorkoutViewController = navigationController.viewControllers.first as! AddWorkoutViewController
            addWorkoutViewController.model = model
        case "showExercises":
            if let row = tableView.indexPathForSelectedRow?.row {
                let workout = model.workoutStore.workouts[row]
                
                let workoutExercisesViewController = segue.destination as! WorkoutExercisesViewController
                workoutExercisesViewController.model = model
                workoutExercisesViewController.workout = workout
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.workoutStore.workouts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutCell
        
        let workout = model.workoutStore.workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
        cell.dateLabel.text = dateFormatter.string(from: workout.dateCreated! as Date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let workout = model.workoutStore.workouts[indexPath.row]
            
            let title = "Delete \(workout.name!)?"
            let message = "Are you sure you want to delete this workout?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.model.workoutStore.removeWorkout(workout)
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        model.workoutStore.moveWorkout(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
}
