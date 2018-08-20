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
    
    @IBOutlet var tableView: UITableView!
    
    //-- TODO: refactor this store to somewhere else
    // as it does not make sense here (i think?)
    // Its only here because otherwise if i put it
    // in the AddExerciseViewController it would be
    // recreated each time the view loads therefore
    // recreated the objects in memory and making
    // the select exercise feature not work
    var exerciseStore = ExerciseStore()
    //--
    
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
        case "showExercises":
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
