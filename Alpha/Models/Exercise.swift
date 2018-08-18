//
//  Exercise.swift
//  Alpha
//
//  Created by Aiden Garipoli on 18/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

class Exercise {
    
    let name: String
    
    let muscles: [Muscle]
    
    init(name: String, muscles: [Muscle]) {
        self.name = name
        self.muscles = muscles
    }
    
}
