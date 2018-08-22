//
//  WorkoutCardTableViewCell.swift
//  Alpha
//
//  Created by Aiden Garipoli on 22/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class WorkoutCardTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var workouts: [Workout]!
    
    // MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    
    // MARK: - Lifecylce Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
        print(#function)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print(#function)
        
        collectionView.reloadData()
    }
    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        print(#function)
//
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        print(#function)
//    }
    
    // MARK: - Collection View DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Workouts Count: \(workouts.count)")
        return workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkoutCardCell", for: indexPath) as! WorkoutCard
        
        print("Workout Name In Cell: \(workouts[indexPath.item].name)")
        
        cell.backgroundColor = UIColor.red
        cell.workout = workouts[indexPath.item]
        
        return cell
    }
    
}

extension WorkoutCardTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 120, height: 120)
        
        return size
    }
    
}
