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
    
    var newWorkoutViewModel: WorkoutViewModel!
    
    var model: Model!
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var workoutNameField: UITextField!
    
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        // save the new workout
        guard !workoutNameField.text!.isEmpty else {
            return
        }
        
        newWorkoutViewModel.workout.name = workoutNameField.text!
        
        model.workoutStore.save()
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        model.workoutStore.removeWorkout(newWorkoutViewModel.workout)
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newWorkout = model.workoutStore.createNewWorkout()
        newWorkoutViewModel = WorkoutViewModel(withWorkout: newWorkout)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateLabel.text = newWorkoutViewModel.formattedDate()
        
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
            selectExerciseViewController.workout = newWorkoutViewModel.workout
            selectExerciseViewController.model = model
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Exercises"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newWorkoutViewModel.exerciseInstanceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exerciseInstancesArray = newWorkoutViewModel.exerciseInstancesArray()
        
        let exercise = exerciseInstancesArray[indexPath.row].exercise
        
        cell.textLabel?.text = exercise?.name
        cell.imageView?.image = UIImage(named: exercise!.mechanics!)
        
        return cell
    }
    
    // MARK: - Private Instance Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
