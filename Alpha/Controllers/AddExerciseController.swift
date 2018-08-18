//
//  AddExerciseController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class AddExerciseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet var exercisesTableView: UITableView!
    
    // MARK: - Properties
    
    var exercises = [Exercise]()
    
    var filteredExercises = [Exercise]()
    
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
        
        // temporary data. will come from REST API
        exercises = [
            Exercise(name: "Bench Press", muscles: [.chest, .shoulders]),
            Exercise(name: "Pull Up", muscles: [.lats, .biceps]),
            Exercise(name: "Dip", muscles: [.chest, .triceps, .shoulders]),
            Exercise(name: "Push Up", muscles: [.chest, .shoulders, .triceps]),
            Exercise(name: "Bodyweight Row", muscles: [.lats])
        ]
        
        exercisesTableView.dataSource = self
        exercisesTableView.delegate = self
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredExercises.count
        }
        
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath)
        
        let exercise: Exercise
        
        if isFiltering() {
            exercise = filteredExercises[indexPath.row]
        } else {
            exercise = exercises[indexPath.row]
        }
        
        cell.textLabel?.text = exercise.name
        
        return cell
    }
    
    // MARK: - Private Instance Methods
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredExercises = exercises.filter({ (exercise) -> Bool in
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

extension AddExerciseController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
}

extension AddExerciseController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
}
