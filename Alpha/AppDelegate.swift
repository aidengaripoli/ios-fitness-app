//
//  AppDelegate.swift
//  Alpha
//
//  Created by Aiden Garipoli on 13/8/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let persistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Alpha")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        })
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let workoutStore = WorkoutStore(container: persistantContainer)
        let exerciseStore = ExerciseStore(container: persistantContainer)
        
        if ProcessInfo.processInfo.arguments.contains("IS_RUNNING_UITEST") {
            exerciseStore._deleteAllExercises()
            workoutStore.seed()
        }
        
        let model = Model(workoutStore: workoutStore, exerciseStore: exerciseStore)
        
        let tabController = window!.rootViewController as! UITabBarController
        
        let navigationController = tabController.childViewControllers[1] as! UINavigationController
        let workoutsController = navigationController.topViewController as! WorkoutsViewController
        workoutsController.model = model
        
        let homeViewController = tabController.childViewControllers[0] as! HomeViewController
        homeViewController.model = model
        
        let profileViewController = tabController.childViewControllers[2] as! ProfileViewController
        profileViewController.imageStore = ImageStore()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

