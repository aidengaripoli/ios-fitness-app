//
//  HomeViewController.swift
//  Alpha
//
//  Created by Aiden Garipoli on 22/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var workoutStore: WorkoutStore!
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Actions
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for w in workoutStore.workouts {
            print(w.name)
        }
        
        tableView.reloadData()
    }

    // MARK: - Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCardTableViewCell", for: indexPath) as! WorkoutCardTableViewCell
        
        print(#function)
        print(workoutStore.workouts)
        
        cell.workouts = workoutStore.workouts
        
        return cell
    }
    
}
