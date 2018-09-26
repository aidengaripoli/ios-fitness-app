//
//  ExerciseStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 19/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit

enum ExercisesResult {
    case success([Exercise])
    case failure(Error)
}

class ExerciseStore {
    
    var exercises: [Exercise]
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    init() {
        exercises = []
        
        
        
//        exercises = [
//            Exercise(name: "Bench Press", muscles: [.chest, .shoulders]),
//            Exercise(name: "Pull Up", muscles: [.lats, .biceps]),
//            Exercise(name: "Dip", muscles: [.chest, .triceps, .shoulders]),
//            Exercise(name: "Push Up", muscles: [.chest, .shoulders, .triceps]),
//            Exercise(name: "Bodyweight Row", muscles: [.lats]),
//            Exercise(name: "Squat", muscles: [.quads]),
//            Exercise(name: "Calf Raises", muscles: [.calves])
//        ]
    }
    
    func fetchExercises(completion: @escaping (ExercisesResult) -> Void) {
        let url = AlphaAPI.exercisesURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processExercisesRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
        
        print("done")
    }
    
    func processExercisesRequest(data: Data?, error: Error?) -> ExercisesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return AlphaAPI.exercises(fromJSON: jsonData)
    }
    
}
