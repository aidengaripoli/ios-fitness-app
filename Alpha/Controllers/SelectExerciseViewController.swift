//
//  AddExerciseController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class SelectExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    
    var workout: Workout!
    
    var exerciseStore = Model.shared.exerciseStore
    
    var filteredExercises = [Exercise]()
    
    var selectedIndexPaths = [IndexPath]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // TODO: figure out a wait to allow ALL muscles to be used as scopes
        searchController.searchBar.scopeButtonTitles = ["All", "Chest", "Shoulders", "Lats", "Biceps"]
        searchController.searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
        
        updateSelectedExercises()
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredExercises.count
        }
        
        return exerciseStore.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        
        let exercise: Exercise
        
        if isFiltering() {
            exercise = filteredExercises[indexPath.row]
        } else {
            exercise = exerciseStore.exercises[indexPath.row]
        }
        
        var musclesString = ""
        
        for (index, muscle) in exercise.muscles.enumerated() {
            musclesString.append(muscle.rawValue.capitalized)
            
            if index != exercise.muscles.count - 1 {
                musclesString.append(", ")
            }
        }
        
        cell.nameLabel.text = exercise.name
        cell.musclesLabel.text = musclesString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let exercise: Exercise
        
        if isFiltering() {
            exercise = filteredExercises[indexPath.row]
        } else {
            exercise = exerciseStore.exercises[indexPath.row]
        }
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            for instance in workout.exerciseInstances {
                if instance.exercise === exercise {
                    workout.exerciseInstances.remove(at: workout.exerciseInstances.index(of: instance)!)
                }
            }
        } else {
            selectedIndexPaths.append(indexPath)
            let instance = ExerciseInstance(exercise: exercise)
            workout.exerciseInstances.append(instance)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if selectedIndexPaths.index(of: indexPath) != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // MARK: - Private Instance Methods
    
    func updateSelectedExercises() {
        selectedIndexPaths.removeAll()
        
        var exercises: [Exercise]
        
        if isFiltering() {
            exercises = filteredExercises
        } else {
            exercises = exerciseStore.exercises
        }
        
        for instance in workout.exerciseInstances {
            if let index = exercises.index(of: instance.exercise) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
        
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredExercises = exerciseStore.exercises.filter({ (exercise) -> Bool in
            var doesMuscleMatch = scope == "All"
            
            for muscle in exercise.muscles {
                if muscle.rawValue == scope.lowercased() {
                    doesMuscleMatch = true
                }
            }
            
            if searchBarIsEmpty() {
                return doesMuscleMatch
            }
            
            return doesMuscleMatch && exercise.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
}

// MARK: - Extensions

extension SelectExerciseViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
}

extension SelectExerciseViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        updateSelectedExercises()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.selectedScopeButtonIndex = 0
        searchBar.text = ""
        
        updateSelectedExercises()
    }
    
}
