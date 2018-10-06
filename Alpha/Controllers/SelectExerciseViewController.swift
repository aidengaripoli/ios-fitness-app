//
//  AddExerciseController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit
import CoreData

class SelectExerciseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties

    var exercises =  [Exercise]()
    
    var workout: Workout! {
        didSet {
            navigationItem.title = workout.name
        }
    }
    
    var model: Model!
    
    var filteredExercises = [Exercise]()
    var selectedIndexPaths = [IndexPath]()
    
    let searchController = UISearchController(searchResultsController: nil)
    let segment: UISegmentedControl = UISegmentedControl(items: ["All", "Isolation", "Compound"])
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segment.sizeToFit()
        segment.selectedSegmentIndex = 0;
        self.navigationItem.titleView = segment
        segment.addTarget(self, action: #selector(requestExercises(sender:)), for: .valueChanged)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Exercises"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.scopeButtonTitles = ["All", "Chest", "Shoulders", "Lats", "Biceps"]
        searchController.searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 68
        
        // fetch from all exercises core data, then load the array into the data source
        // for the table view. then do a network fetch request to get all exercises from
        // the api, save the new exercises in core data if they dont exist, re fetch all
        // exercises and reload the tableview.
        
        updateDataSource() // fetches from COREDATA and loads into datasource array

        // networking fetch
        showFetchingIndicatorAlert()
        
        model.exerciseStore.requestAllExercises { (exercisesResult) in
            // fetches from core data, now with possibly more data, and reloads the tableview
            self.updateDataSource()
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredExercises.count
        }
        
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseCell
        
        let exercise: Exercise
        
        if isFiltering() {
            exercise = filteredExercises[indexPath.row]
        } else {
            exercise = exercises[indexPath.row]
        }
        
        var musclesString = ""
        
        // convert muscles to array to display them
        let muscles = exercise.muscles?.allObjects as! Array<Muscle>
        
        for (index, muscle) in muscles.enumerated() {
            musclesString.append(muscle.name!.capitalized)
            
            if index != (exercise.muscles?.count)! - 1 {
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
            exercise = exercises[indexPath.row]
        }
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            
            for instance in workout.exerciseInstances as! Set<ExerciseInstance> {
                if instance.exercise === exercise {
                    workout.removeFromExerciseInstances(instance)
                    
                    model.workoutStore.deleteExerciseInstance(exerciseInstance: instance)
                }
            }
        } else {
            selectedIndexPaths.append(indexPath)
            
            model.workoutStore.createExerciseInstance(exercise: exercise, workout: workout)
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
    
    private func updateDataSource() {
        // fetch all exercise from core data and update the exercise array
        let segmentSelection = segment.titleForSegment(at: segment.selectedSegmentIndex)
        
        if let mechanics = Mechanics(rawValue: segmentSelection!.lowercased()) {
            
            model.exerciseStore.fetchExercises (mechanics: mechanics) { (result) in
                switch result {
                case let .success(exercises):
                    self.exercises = exercises
                case .failure:
                    self.exercises.removeAll()
                }
                
                // update the exercises that the workout has selected
                self.updateSelectedExercises()
            }
        }
    }
    
    func updateSelectedExercises() {
        selectedIndexPaths.removeAll()
        
        var exercises: [Exercise]
        
        if isFiltering() {
            exercises = filteredExercises
        } else {
            exercises = self.exercises
        }
        
        for instance in workout.exerciseInstances as! Set<ExerciseInstance> {
            if let index = exercises.index(of: instance.exercise!) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredExercises = exercises.filter({ (exercise) -> Bool in
            var doesMuscleMatch = scope == "All"
            
            // convert muscles to array to display them
            let muscles = exercise.muscles?.allObjects as! Array<Muscle>
            
            for muscle in muscles {
                if muscle.name == scope.lowercased() {
                    doesMuscleMatch = true
                }
            }
            
            if searchBarIsEmpty() {
                return doesMuscleMatch
            }
            
            return doesMuscleMatch && exercise.name!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    @objc func requestExercises(sender: UISegmentedControl) {
        showFetchingIndicatorAlert()
        
        switch sender.selectedSegmentIndex {
        case 0:
            model.exerciseStore.requestAllExercises { (exercisesResult) in
                self.updateDataSource()
                self.dismiss(animated: true, completion: nil)
            }
        case 1:
            model.exerciseStore.requestIsolationExercises { (exercisesResult) in
                self.updateDataSource()
                self.dismiss(animated: false, completion: nil)
            }
        case 2:
            model.exerciseStore.requestCompoundExercises { (exercisesResult) in
                self.updateDataSource()
                self.dismiss(animated: false, completion: nil)
            }
        default:
            break
        }
    }
    
    func showFetchingIndicatorAlert() {
        let alert = UIAlertController(title: nil, message: "Fetching...", preferredStyle: .alert)
        
        let fetchingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        fetchingIndicator.hidesWhenStopped = true
        fetchingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        fetchingIndicator.startAnimating()
        
        alert.view.addSubview(fetchingIndicator)
        present(alert, animated: true, completion: nil)
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
