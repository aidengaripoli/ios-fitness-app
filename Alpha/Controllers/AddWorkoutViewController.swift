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
    
    var newWorkout = Model.shared.createNewWorkout()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
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
        
//        workoutStore.workouts.append(newWorkout)
        Model.shared.saveNewWorkout(workout: newWorkout)
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateLabel.text = dateFormatter.string(from: newWorkout.dateCreated)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectExercises":
            let selectExerciseViewController = segue.destination as! SelectExerciseViewController
            selectExerciseViewController.workout = newWorkout
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exercises"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newWorkout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise = newWorkout.exercises[indexPath.row]
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    // MARK: - Private Instance Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
