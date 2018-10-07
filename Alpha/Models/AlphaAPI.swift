//
//  AlphaAPI.swift
//  Alpha
//
//  Created by Aiden Garipoli on 25/9/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation
import CoreData

enum AlphaAPIError: Error {
    case invalidJSONData
}
enum Mechanics: String {
    case all
    case isolation
    case compound
}

struct AlphaAPI {

    private static let baseURLString = "http://167.99.79.170/exercises"

    static var baseExerciseURL: URL {
        return alphaURL(mechanics: .all)
    }
    
    static var isolationURL: URL {
        return alphaURL(mechanics: .isolation)
    }
    
    static var compoundURL: URL {
        return alphaURL(mechanics: .compound)
    }

    private static func alphaURL(mechanics: Mechanics) -> URL {
        var components = URLComponents(string: baseURLString)!

        if mechanics == .all {
            return components.url!
        }
        
        var queryItems = [URLQueryItem]()
        queryItems.append(
            URLQueryItem(name: "mechanics", value: mechanics.rawValue)
        )
        
        components.queryItems = queryItems
        
        return components.url!
    }

    static func exercises(fromJSON data: Data, into context: NSManagedObjectContext) -> ExercisesResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let exerciseArray = jsonDictionary["exercises"] as? [[String: Any]] else {
                    return .failure(AlphaAPIError.invalidJSONData)
            }

            var finalExercises = [Exercise]()

            for exerciseJSON in exerciseArray {
                if let exercise = exercise(fromJSON: exerciseJSON, into: context) {
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

    private static func exercise(fromJSON json: [String: Any], into context: NSManagedObjectContext) -> Exercise? {
        guard
            let exerciseID = json["_id"] as? String,
            let name = json["name"] as? String,
            let mechanics = json["mechanics"] as? String,
            let muscleArray = json["muscles"] as? [[String: String]] else {
                return nil
        }

        // attempt to find exercise in core data with the same id
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Exercise.exerciseID)) == %@", exerciseID)
        
        fetchRequest.predicate = predicate
        
        var fetchedExercises: [Exercise]?
        
        context.performAndWait {
            fetchedExercises = try? fetchRequest.execute()
        }
        
        // if exercise is found, return it
        if let existingExercise = fetchedExercises?.first {
            return existingExercise
        }
        
        // otherwise create a new exercise object
        var exercise: Exercise!
        
        context.performAndWait {
            exercise = Exercise(context: context)
            exercise.exerciseID = exerciseID
            exercise.name = name
            exercise.mechanics = mechanics
        }
        
        // do the same for all muscles associated with the current exercise
        for muscleJSON in muscleArray {
            if let muscle = muscle(fromJSON: muscleJSON, into: context) {
                muscle.exercise = exercise
            }
        }
        
        return exercise
    }

    private static func muscle(fromJSON json: [String: Any], into context: NSManagedObjectContext) -> Muscle? {
        guard
            let muscleID = json["_id"] as? String,
            let name = json["name"] as? String else {
                return nil
        }

        // attempt to find muscle in core data with the same id
        let fetchRequest: NSFetchRequest<Muscle> = Muscle.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Muscle.muscleID)) == %@", muscleID)
        
        fetchRequest.predicate = predicate
        
        var fetchedMuscles: [Muscle]?
        
        context.performAndWait {
            fetchedMuscles = try? fetchRequest.execute()
        }
        
        // if muscle is found, return it
        if let existingMuscle = fetchedMuscles?.first {
            return existingMuscle
        }
        
        // otherwise create a new muscle object
        var muscle: Muscle!
        
        context.performAndWait {
            muscle = Muscle(context: context)
            muscle.name = name
        }
        
        return muscle
    }

}
