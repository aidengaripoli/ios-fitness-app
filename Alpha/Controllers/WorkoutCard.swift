//
//  WorkoutCard.swift
//  Alpha
//
//  Created by Aiden Garipoli on 22/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class WorkoutCard: UICollectionViewCell {
    
    // MARK: - Properties
    
    var workout: Workout! {
        didSet {
            print("didSet")
            nameLabel.text = workout.name
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
