//
//  WorkoutStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 15/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation
import CoreData

enum WorkoutsResult {
    case success([Workout])
    case failure(Error)
}

class WorkoutStore {
    
    // MARK: - Stored Properties
    
    var workouts = [Workout]()
    
    var persistantContainer: NSPersistentContainer!
    
    // MARK: - Init
    
    init(container: NSPersistentContainer) {
        self.persistantContainer = container
    }
    
    // MARK: - Methods
    
//    func fetchAllWorkouts(completion: @escaping (WorkoutsResult) -> Void) {
//        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
//        let sortByDateCreated = NSSortDescriptor(key: #keyPath(Workout.dateCreated), ascending: true)
//
//        fetchRequest.sortDescriptors = [sortByDateCreated]
//
//        let context = persistantContainer.viewContext
//
//        context.perform {
//            do {
//                let allWorkouts = try context.fetch(fetchRequest)
//                self.workouts = allWorkouts
//                completion(.success(allWorkouts))
//            } catch {
//                completion(.failure(error))
//            }
//        }
//    }
    
    func fetchAllWorkouts() {
        let fetchRequest: NSFetchRequest<Workout> = Workout.fetchRequest()
        let sortByDateCreated = NSSortDescriptor(key: #keyPath(Workout.dateCreated), ascending: true)

        fetchRequest.sortDescriptors = [sortByDateCreated]

        let context = persistantContainer.viewContext

        context.performAndWait {
            do {
                self.workouts = try context.fetch(fetchRequest)
            } catch {
                print("Error could not fetch workouts: \(error)")
            }
        }
    }

    
    // TODO: refactor/remove these methods
    
    func removeWorkout(_ workout: Workout) {
        persistantContainer.viewContext.delete(workout)
        
        do {
            try persistantContainer.viewContext.save()
            
            fetchAllWorkouts()
        } catch {
            print("Error saving to Core Data: \(error)")
        }
    }
    
    func moveWorkout(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }

        let movedWorkout = workouts[fromIndex]

        workouts.remove(at: fromIndex)

        workouts.insert(movedWorkout, at: toIndex)
    }

    func createNewWorkout() -> Workout {
        let workout = NSEntityDescription.insertNewObject(forEntityName: "Workout", into: persistantContainer.viewContext) as! Workout
        
//        workout.name = ""
        workout.dateCreated = Date() as NSDate
        
        return workout
    }
    
    func createSet(weight: Int, reps: Int, exerciseInstance: ExerciseInstance) {
        let set = NSEntityDescription.insertNewObject(forEntityName: "ExerciseSet", into: persistantContainer.viewContext) as! ExerciseSet
        
        set.exerciseInstance = exerciseInstance
        
        set.weight = 0
        set.reps = 0
        
        exerciseInstance.addToSets(set)
        
        save()
    }
    
    func save() {
        do {
            try persistantContainer.viewContext.save()
            
            fetchAllWorkouts()
        } catch {
            print("Error: \(error)")
        }
    }
    
}
