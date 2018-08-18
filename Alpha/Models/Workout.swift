//
//  Workout.swift
//  Alpha
//
//  Created by Aiden Garipoli on 15/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class Workout: NSObject {
    
    var name: String
    let dateCreated: Date
    
    init(name: String) {
        self.name = name
        self.dateCreated = Date()
    }
}
