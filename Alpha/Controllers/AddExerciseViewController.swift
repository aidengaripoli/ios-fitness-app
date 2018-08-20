//
//  AddExerciseController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet var exercisesTableView: UITableView!
    
    // MARK: - Properties
    
    var workout: Workout!
    
//    var workoutStore: WorkoutStore // not sure if needed yet
    
//    var exercises = [Exercise]()
    var exerciseStore: ExerciseStore! // replace with a store
    
    var filteredExercises = [Exercise]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedIndexPaths = [IndexPath]()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AddExerciseViewController - \(#function)")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // TODO: figure out a wait to allow ALL muscles to be used as scopes
        searchController.searchBar.scopeButtonTitles = ["All", "Chest", "Shoulders", "Lats", "Biceps"]
        searchController.searchBar.delegate = self
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise: Exercise
        
        if isFiltering() {
            exercise = filteredExercises[indexPath.row]
        } else {
            exercise = exerciseStore.exercises[indexPath.row]
        }
        
        cell.textLabel?.text = exercise.name
        
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
            if let exerciseIndex = workout.exercises.index(of: exercise) {
                workout.exercises.remove(at: exerciseIndex)
            }
        } else {
            selectedIndexPaths.append(indexPath)
            workout.exercises.append(exercise)
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
        
        for exercise in workout.exercises {
            if let index = exercises.index(of: exercise) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
        
        exercisesTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        
        exercisesTableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
}

// MARK: - Extensions

extension AddExerciseViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
}

extension AddExerciseViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        updateSelectedExercises()
    }
    
}
