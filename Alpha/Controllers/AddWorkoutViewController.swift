//
//  AddWorkoutController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var newWorkout = Workout()
    
    var workoutStore: WorkoutStore!
    
    //-- TODO: refactor this store to somewhere else
    // as it does not make sense here (i think?)
    // Its only here because otherwise if i put it
    // in the AddExerciseViewController it would be
    // recreated each time the view loads therefore
    // recreated the objects in memory and making
    // the select exercise feature not work
    var exerciseStore = ExerciseStore()
    //--
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var workoutNameField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // save the new workout
        // need to validate the name label first however.
        
        // temp. assume not empty
        newWorkout.name = workoutNameField.text!
        
        workoutStore.workouts.append(newWorkout)
    
        for w in workoutStore.workouts {
            print("Workout Store: \(w.name)")
        }
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AddWorkoutViewController - \(#function)")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("AddWorkoutViewController - \(#function)")
    }
 
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectExercises":
            let addExerciseViewController = segue.destination as! AddExerciseViewController
            addExerciseViewController.workout = newWorkout
            addExerciseViewController.exerciseStore = exerciseStore
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newWorkout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise = newWorkout.exercises[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
}
