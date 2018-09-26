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
    
    // MARK: - Properties
    
    var exercises = [Exercise]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // MARK: - Methods
    
    func fetchExercises(completion: @escaping (ExercisesResult) -> Void) {
        let url = AlphaAPI.exercisesURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processExercisesRequest(data: data, error: error)
            completion(result)
        }
        
        task.resume()
    }
    
    func processExercisesRequest(data: Data?, error: Error?) -> ExercisesResult {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return AlphaAPI.exercises(fromJSON: jsonData)
    }
    
}
