//
//  AlphaAPI.swift
//  Alpha
//
//  Created by Aiden Garipoli on 25/9/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation

enum AlphaAPIError: Error {
    case invalidJSONData
}

enum Endpoint: String {
    case exercises = "exercises"
    case muscles = "muscles"
}

struct AlphaAPI {
    
    private static let baseURLString = "http://167.99.79.170/"
    
    static var exercisesURL: URL {
        return alphaURL(endpoint: .exercises)
    }
    
    static var musclesURL: URL {
        return alphaURL(endpoint: .muscles)
    }
    
    private static func alphaURL(endpoint: Endpoint) -> URL {
        let components = URLComponents(string: baseURLString + endpoint.rawValue)!
        
        return components.url!
    }
    
    static func exercises(fromJSON data: Data) -> ExercisesResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let exerciseArray = jsonDictionary["exercises"] as? [[String: Any]] else {
                    return .failure(AlphaAPIError.invalidJSONData)
            }
            
            var finalExercises = [Exercise]()
            
            for exerciseJSON in exerciseArray {
                if let exercise = exercise(fromJSON: exerciseJSON) {
                    finalExercises.append(exercise)
                }
            }
            
            if finalExercises.isEmpty && !exerciseArray.isEmpty {
                return .failure(AlphaAPIError.invalidJSONData)
            }
            
            return .success(finalExercises)
        } catch let error {
            return .failure(error)
        }
    }
    
    private static func exercise(fromJSON json: [String: Any]) -> Exercise? {
        guard
//            let exerciseID = json["_id"] as? String,
            let name = json["name"] as? String,
            let muscleArray = json["muscles"] as? [[String: String]] else {
                return nil
        }
        
        var finalMuscles = [Muscle]()
        
        for muscleJSON in muscleArray {
            if let muscle = muscle(fromJSON: muscleJSON) {
                finalMuscles.append(muscle)
            }
        }
        
        if finalMuscles.isEmpty && !muscleArray.isEmpty {
            return nil
        }
        
        return Exercise(name: name, muscles: finalMuscles)
    }
    
    private static func muscle(fromJSON json: [String: Any]) -> Muscle? {
        guard let name = json["name"] as? String else {
            return nil
        }
        
        return Muscle(rawValue: name)
    }
    
}
