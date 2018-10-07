//
//  AddWorkoutController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class AddWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WorkoutViewModelProtocol {
    
    // MARK: - Properties
    
    var workoutViewModel: WorkoutViewModel!
    
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
        
        workoutViewModel.workout.name = workoutNameField.text!
        
        model.workoutStore.save()
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        model.workoutStore.removeWorkout(workoutViewModel.workout)
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newWorkout = model.workoutStore.createNewWorkout()
        workoutViewModel = WorkoutViewModel(withWorkout: newWorkout)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateLabel.text = workoutViewModel.formattedDate()
        
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
            selectExerciseViewController.workout = workoutViewModel.workout
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
        return workoutViewModel.exerciseInstanceCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exerciseInstancesArray = workoutViewModel.exerciseInstancesArray()
        
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
