//
//  HomeViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 22/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var workoutStore = Model.shared.workoutStore
    
    var previousWorkouts: [Workout] = []
    
    var currentWorkouts: [Workout] = []
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // temp
        tableView.rowHeight = 200
        
        //temp
        workoutStore.createDummyWorkouts(amount: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previousWorkouts.removeAll()
        currentWorkouts.removeAll()
        
        for workout in workoutStore.workouts {
            // 604800 seconds = 7 days
            if Date().addingTimeInterval(-604800) > workout.dateCreated {
                previousWorkouts.append(workout)
            } else {
                currentWorkouts.append(workout)
            }
        }
        
        tableView.reloadData()
    }
    
}

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
        if section == 0 {
            return "Last Week"
        }
        
        return "This Week"
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! WorkoutCardTableViewCell
        cell.collectionView.reloadData()
        cell.collectionView.contentOffset = .zero
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return previousWorkouts.count
        }
        
        return currentWorkouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCardCollectionViewCell", for: indexPath) as! WorkoutCardCollectionViewCell
        
        print("Workout Name In Cell: \(workoutStore.workouts[indexPath.item].name)")
        
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! WorkoutCardCollectionViewCell
        
        let workout: Workout
        
        if collectionView.tag == 0 {
            workout = previousWorkouts[indexPath.item]
        } else {
            workout = currentWorkouts[indexPath.item]
        }
        
        cell.nameLabel.text = workout.name
        cell.dateLabel.text = dateFormatter.string(from: workout.dateCreated)
    }
    
}
