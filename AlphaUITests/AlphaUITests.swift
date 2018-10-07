//
//  AlphaUITests.swift
//  AlphaUITests
//
//  Created by Aiden Garipoli on 13/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import XCTest
import CoreData
@testable import Alpha

class AlphaUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        app.launchArguments.append("IS_RUNNING_UITEST")
        
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        
        app = nil
    }
    
    // MARK: - Profile Screen
    
    func testAgeInput() {
        
        // pre condition: textfield value is empty
        
        app.tabBars.buttons["Profile"].tap()
        
        app.textFields["ageField"].tap()
        
        app.pickers["agePickerView"].pickerWheels["13"].swipeUp()
        
        // action: scroll to select a value
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        // post condition: textfield value has changed
        
        XCTAssertEqual(app.textFields["ageField"].value as! String, "34")
    }
    
    func testHeightInput() {
        
        // pre condition: textfield value is empty
        
        app.tabBars.buttons["Profile"].tap()
        
        app.textFields["heightField"].tap()
        
        app.pickers["heightPickerView"].pickerWheels["50 cms"].swipeUp()
        
        // action: scroll to select a value
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        // post condition: textfield value has changed
        
        XCTAssertEqual(app.textFields["heightField"].value as! String, "71 cms")
    }
    
    func testWeightInput() {
        
        // pre condition: textfield value is empty
        
        app.tabBars.buttons["Profile"].tap()
        
        app.textFields["weightField"].tap()
        
        app.pickers["weightPickerView"].pickerWheels["30 kgs"].swipeUp()
        
        // action: scroll to select a value
        
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        // post condition: textfield value has changed
        
        XCTAssertEqual(app.textFields["weightField"].value as! String, "51 kgs")
    }
    
    // MARK: - Home Screen
    
    func testStartWorkout() {
        
        // pre condition: on home screen
        
        // action: tap start workout button
        
        app.buttons["startWorkoutButton"].tap()
        
        // post condition: on new workout screen
        
        XCTAssert(app.navigationBars["New Workout"].exists)
    }
    
    // MARK: - Workouts Screen
    
    func testNumberWorkout() {
        
        // pre condition: on home screen
        
        // action: tap workouts tab
        
        app.tabBars.buttons["Workouts"].tap()
        
        // post condition: all workouts showing on workouts screen
        
        XCTAssertEqual(app.tables.cells.count, 3)
    }
    
    func testNewWorkout() {
        
        // pre condition: on workouts screen
        
        app.tabBars.buttons["Workouts"].tap()
        
        // action: tap add button
        
        app.navigationBars["Workouts"].buttons["Add"].tap()
        
        // post condition: on addNewWorkout screen
        
        XCTAssert(app.navigationBars["New Workout"].exists)
    }
    
    func testDeleteWorkout() {
        
        // pre condition: 3 workouts in store
        
        app.tabBars.buttons["Workouts"].tap()
        
        // action: delete a workout
        
        let workoutsNavigationBar = app.navigationBars["Workouts"]
        workoutsNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.element(boundBy: 0).buttons.element(boundBy: 0).tap()
        tablesQuery.buttons["Delete"].tap()
        app.sheets["Delete Workout 0?"].buttons["Delete"].tap()
        workoutsNavigationBar.buttons["Done"].tap()
        
        // post condition: 1 less workouts
        
        XCTAssertEqual(tablesQuery.cells.count, 2)
    }
    
    func testTapWorkoutCell() {
        
        app.tabBars.buttons["Workouts"].tap()
        
        // pre condition: on workouts screen
        
        // action: tap workout cell
        
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Workout 0"].tap()
        
        // post condition: on workout screen
        
        XCTAssert(app.navigationBars["Workout 0"].exists)
    }
    
    // MARK: - Workout Exercises Screen
    
    func testNumberExercises() {
        app.tabBars.buttons["Workouts"].tap()
        
        // pre condition: on workouts screen
        
        // action: tap workout 0 workout cell
        
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Workout 0"].tap()
        
        // post condition: all exercises present
        
        XCTAssertEqual(app.tables.cells.count, 1)
    }
    
    func testSelectExercises() {
        app.tabBars.buttons["Workouts"].tap()

        // pre condition: on workouts screen

        // action: tap workout 0 workout cell, tap edit

        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Workout 0"].tap()

        app.navigationBars["Workout 0"].buttons["Edit"].tap()

        // post condition: on select exercises screen for workout 0

        XCTAssertGreaterThan(app.tables.cells.count, 0)
    }
    
    func testBackToWorkouts() {
        app.tabBars.buttons["Workouts"].tap()
        
        // pre condition: on workouts screen
        
        // action: tap on workout 0 workout cell, tap on workouts back button
        
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Workout 0"].tap()
        
        app.navigationBars["Workout 0"].buttons["Workouts"].tap()
        
        // post condition: back on workout screen
        
        XCTAssert(app.navigationBars["Workouts"].exists)
    }
    
    func testTapExerciseCell() {
        app.tabBars.buttons["Workouts"].tap()
        
        // pre condition: on workouts screen
        
        // action: tap workout 0 workout cell, tap bench press exercise cell
        
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["Workout 0"].tap()
        
        app.tables.staticTexts["Test Exercise"].tap()
        
        // post condition: on test exercise detail screen
        
        XCTAssert(app.navigationBars["Test Exercise"].exists)
    }
    
    // MARK: - Add Workout Screen
    
    func testSelectExercisesButton() {
        
        app.buttons["startWorkoutButton"].tap()
        
        // pre condition: on workouts screen

        // action: tap selectExercises button
        
        app.buttons["selectExercises"].tap()
        
        // post condition:
        XCTAssertGreaterThan(app.tables.cells.count, 0)
    }
    
    // MARK: - Select Exercises Screen
    
    func testNumberOfExercises() {
        
        // pre condition: on home screen
        
        // action: navigate to select exercises screen
        
        app.buttons["startWorkoutButton"].tap()
        
        app.buttons["selectExercises"].tap()
        
        // post condition: all exercises are present
        
        XCTAssertEqual(app.tables.cells.count, 1)
    }
    
    // MARK: - Use Case
    
    func testCreateWorkoutAndRecordData() {
        app.buttons["startWorkoutButton"].tap()
        
        app.textFields["nameField"].tap()
        
        app.keyboards.keys["t"].tap()
        app.keyboards.keys["e"].tap()
        app.keyboards.keys["s"].tap()
        app.keyboards.keys["t"].tap()
        
        app.tables.containing(.other, identifier:"Exercises").element.tap()
        app.buttons["selectExercises"].tap()
        
        addUIInterruptionMonitor(withDescription: "Loading") { alert in
            self.expectation(for: NSPredicate(format: "exists == false"), evaluatedWith: alert, handler: nil);
            self.waitForExpectations(timeout: 10, handler: nil)
            return true
        }
        
        app.tables.staticTexts["Test Exercise"].tap()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars["New Workout"].buttons["Save"].tap()
        app.tabBars.buttons["Workouts"].tap()
        
        app.cells.element(boundBy: 0).tap()
        app.cells.staticTexts["Test Exercise"].tap()
        
        let weightField = app.tables.cells.children(matching: .textField).element(boundBy: 1)
        
        weightField.tap()
        app.pickers["weightPickerView"].pickerWheels["0 kgs"].swipeUp()
        
        let repsField = app.tables.cells.children(matching: .textField).element(boundBy: 0)
        
        repsField.tap()
        app.pickers["repsPickerView"].pickerWheels["1 reps"].swipeUp()
        
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        XCTAssertEqual(app.tables.cells.count, 4)
    }
    
}
