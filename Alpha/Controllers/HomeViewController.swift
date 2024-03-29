//
//  HomeViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 22/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, WorkoutViewModelProtocol {

    // MARK: - Properties
    
    var model: Model!

    var workoutViewModel: WorkoutViewModel!
    
    var previousWorkouts: [Workout] = []
    var currentWorkouts = [Workout]()
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!

    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 200
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previousWorkouts.removeAll()
        currentWorkouts.removeAll()
        
        for workout in model.workoutStore.workouts {
            // 604800 seconds = 7 days
            let sevenDays = Date().addingTimeInterval(-604800)
            let fourteenDays = Date().addingTimeInterval(-1209600)
            
            let workoutDate = workout.dateCreated! as Date
            
            if workoutDate >= sevenDays {
                currentWorkouts.append(workout)
            } else if workoutDate <= sevenDays && workoutDate >= fourteenDays {
                previousWorkouts.append(workout)
            }
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addWorkout":
            let navigationController = segue.destination as! UINavigationController
            let addWorkoutViewController = navigationController.viewControllers.first as! AddWorkoutViewController
            addWorkoutViewController.model = model
        default:
            preconditionFailure("Unexpected Segue Identifier")
        }
    }
    
}

// MARK: - TableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCardTableViewCell", for: indexPath) as! WorkoutCardTableViewCell
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        cell.collectionView.tag = indexPath.section
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Last Week" : "This Week"
    }
    
}

// MARK: - TableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! WorkoutCardTableViewCell
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset = .zero
    }
    
}

// MARK: - CollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? previousWorkouts.count : currentWorkouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCardCollectionViewCell", for: indexPath) as! WorkoutCardCollectionViewCell
        
        return cell
    }
    
}

// MARK: - CollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! WorkoutCardCollectionViewCell
        
        cell.view.layer.borderWidth = 1
        cell.view.layer.borderColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1).cgColor
        
        let workout: Workout
        
        workout = collectionView.tag == 0 ? previousWorkouts[indexPath.item] : currentWorkouts[indexPath.item]
        
        workoutViewModel = WorkoutViewModel(withWorkout: workout)
        
        cell.nameLabel.text = workout.name
        cell.dateLabel.text = workoutViewModel.formattedDate()
        cell.exerciseSummary.text = "\(workout.exerciseInstances!.count) exercises"
        
        var totalReps: Int32 = 0
        let instances = workout.exerciseInstances?.allObjects as! [ExerciseInstance]
        for instance in instances {
            for set in instance.sets?.allObjects as! [ExerciseSet] {
                totalReps += set.reps
            }
        }
        
        cell.totalRepsLabel.text = "\(totalReps) reps completed!"
    }
    
}
