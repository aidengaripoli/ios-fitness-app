//
//  ExerciseStore.swift
//  Alpha
//
//  Created by Aiden Garipoli on 19/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit
import CoreData

enum ExercisesResult {
    case success([Exercise])
    case failure(Error)
}

class ExerciseStore {
    
    // MARK: - Properties
    
//    var exercises = [Exercise]()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    let persistantContainer: NSPersistentContainer!
    
    // MARK: - Init
    
    init(container: NSPersistentContainer) {
        self.persistantContainer = container
    }
    
    // MARK: - Methods
    
    func fetchAllExercises(completion: @escaping (ExercisesResult) -> Void) {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Exercise.name), ascending: true)
        
        fetchRequest.sortDescriptors = [sortByName]
        
        let context = persistantContainer.viewContext
        
        context.perform {
            do {
                let allExercises = try context.fetch(fetchRequest)
                completion(.success(allExercises))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchExercises(mechanics: Mechanics, completion: @escaping (ExercisesResult) -> Void) {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Exercise.name), ascending: true)
        
        if mechanics != .all {
            let predicate = NSPredicate(format: "\(#keyPath(Exercise.mechanics)) == %@", mechanics.rawValue)
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = [sortByName]
        
        let context = persistantContainer.viewContext
        
        context.perform {
            do {
                let allExercises = try context.fetch(fetchRequest)
                completion(.success(allExercises))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func requestAllExercises(completion: @escaping (ExercisesResult) -> Void) {
        let url = AlphaAPI.baseExerciseURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.processExercisesRequest(data: data, error: error, completion: { (result) in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        }
        
        task.resume()
    }
    
    func requestIsolationExercises(completion: @escaping (ExercisesResult) -> Void) {
        let url = AlphaAPI.isolationURL
        let request = URLRequest(url: url)

        let task = session.dataTask(with: request) { (data, response, error) in
            self.processExercisesRequest(data: data, error: error, completion: { (result) in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        }

        task.resume()
    }
    
    func requestCompoundExercises(completion: @escaping (ExercisesResult) -> Void) {
        let url = AlphaAPI.compoundURL
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            self.processExercisesRequest(data: data, error: error, completion: { (result) in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        }
        
        task.resume()
    }

    func processExercisesRequest(data: Data?, error: Error?, completion: @escaping (ExercisesResult) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }

        persistantContainer.performBackgroundTask { (context) in
            let result = AlphaAPI.exercises(fromJSON: jsonData, into: context)
            
            do {
                try context.save()
            } catch {
                print("Error saving to Core Data: \(error)")
                completion(.failure(error))
                return
            }
            
            switch result {
            case let .success(exercises):
                let exerciseIDs = exercises.map { return $0.objectID }
                let viewContext = self.persistantContainer.viewContext
                let viewContextExercises = exerciseIDs.map { return viewContext.object(with: $0) } as! [Exercise]
                completion(.success(viewContextExercises))
            case .failure:
                completion(result)
            }
        }
    }
    
}
