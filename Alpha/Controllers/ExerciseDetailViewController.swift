//
//  ExerciseDetailViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 24/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController {
    
    // MARK: - Properties

    var exerciseInstance: ExerciseInstance! {
        didSet {
            navigationItem.title = exerciseInstance.exercise.name
        }
    }
    
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Actions
    
    @IBAction func startTimer(_ sender: UIBarButtonItem) {
    
    }
    
    @IBAction func addSet(_ sender: UIBarButtonItem) {
//        if let weight = exerciseInstance.sets.last?.weight,
//            let reps = exerciseInstance.sets.last?.reps {
//            exerciseInstance.sets.append((weight: weight, reps: reps))
//        }
        exerciseInstance.sets.append((weight: 0, reps: 0))
        
        tableView.reloadData()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // temp
        tableView.rowHeight = 100
    }

}

// MARK: - Extension CollectionViewDataSource

extension ExerciseDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseInstance.sets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseSetCell", for: indexPath) as! ExerciseSetCell
        
        cell.setNumberLabel.text = "\(indexPath.row + 1)"
        cell.setWeightTextField.text = "\(exerciseInstance.sets[indexPath.row].weight)"
        cell.setRepsTextField.text = "\(exerciseInstance.sets[indexPath.row].reps)"
        
        return cell
    }
    
}

// MARK: - Extension CollectionViewDataSource

extension ExerciseDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Set - Weight - Reps"
    }
    
}

// MARK: - Extension CollectionViewDataSource

extension ExerciseDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exerciseInstance.exercise.muscles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseMuscleCell", for: indexPath) as! ExerciseMuscleCell
    
        cell.nameLabel.text = exerciseInstance.exercise.muscles[indexPath.row].rawValue.capitalized
        
        return cell
    }
    
}

// MARK: - Extension CollectionViewDelegate

extension ExerciseDetailViewController: UICollectionViewDelegate {
    
}
