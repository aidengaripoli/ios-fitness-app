//
//  AlphaTests.swift
//  AlphaTests
//
//  Created by Aiden Garipoli on 13/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import XCTest
import CoreData
@testable import Alpha

class AlphaTests: XCTestCase {
    
    // MARK: System Under Test
    
    var workoutStore: WorkoutStore!
    
    // MARK: - Core Data Setup
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])
        return managedObjectModel!
    }()
    
    // In memeory core data persistent container
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AlphaTest", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("Failed to set up mock persistent store (\(error))")
            }
        }
        return container
    }()
    
    // MARK: Set Up
    
    override func setUp() {
        super.setUp()
        
        workoutStore = WorkoutStore(container: mockPersistantContainer)
    }
    
    override func tearDown() {
        workoutStore = nil
        
        super.tearDown()
    }
    
    // MARK: Unit Tests
    
    func testCreateWorkout() {
        // given
        var workout: Workout!
        
        // when
        workout = workoutStore.createNewWorkout()
        
        // then
        XCTAssertNotNil(workout)
    }
    
    func testFetchAllWorkouts() {
        // given
        let amount = 3
        
        createWorkoutHelper(amount: amount)
        
        // when
        workoutStore.fetchAllWorkouts()
        
        // then
        XCTAssertEqual(workoutStore.workouts.count, amount)
    }
    
    func testRemoveWorkout() {
        // given
        let amount = 3
        
        createWorkoutHelper(amount: amount)
        
        workoutStore.fetchAllWorkouts()
        
        let workout = workoutStore.workouts[0]
        
        // when
        workoutStore.removeWorkout(workout)
        workoutStore.save()
        
        // then
        XCTAssertEqual(numberOfItemsInPersistentStore(), amount - 1)
    }
    
    func testViewModelDateFormatter() {
        // given
        createWorkoutHelper()
        
        workoutStore.fetchAllWorkouts()
        
        let workout = workoutStore.workouts[0]

        let vm = WorkoutViewModel(withWorkout: workout)

        // when
        let formattedDate = vm.formattedDate()

        // then
        XCTAssertNotNil(formattedDate)
    }
    
    // MARK: - Helper Methods
    
    func createWorkoutHelper(amount: Int = 1) {
        for i in 0..<amount {
            let workout = Workout(context: mockPersistantContainer.viewContext)
            workout.name = "Workout \(i)"
            workout.dateCreated = Date() as NSDate
        }

        try! mockPersistantContainer.viewContext.save()
    }
    
    func numberOfItemsInPersistentStore() -> Int {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        let results = try! mockPersistantContainer.viewContext.fetch(request)
        return results.count
    }
    
}
