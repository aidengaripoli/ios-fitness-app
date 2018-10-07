//
//  ProfileDetails.swift
//  Alpha
//
//  Created by Aiden Garipoli on 5/10/18.
//  Copyright © 2018 Aiden Garipoli. All rights reserved.
//

import Foundation

class ProfileDetails {
    
    private let fileManager = FileManager.default
    
    private let destination: String!
    
    init() {
        let source = Bundle.main.path(forResource: "ProfileDetails", ofType: "plist")
        let docsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        destination = docsDirectory.appendingPathComponent("ProfileDetails.plist")
        
        if !fileManager.fileExists(atPath: destination) {
            do {
                try fileManager.copyItem(atPath: source!, toPath: destination)
            } catch {
                print(error)
            }
        }
    }
    
    func update(key: String, value: Int) {
        if fileManager.fileExists(atPath: destination) {
            let dict = NSMutableDictionary(contentsOfFile: destination)
            
            dict?[key] = value
            
            dict?.write(toFile: destination, atomically: false)
        }
    }
    
    func get(key: String) -> Any? {
        if fileManager.fileExists(atPath: destination) {
            let dict = NSDictionary(contentsOfFile: destination) as? [String: Any]
            
            if let value = dict?[key] {
                return value
            }
        }
        
        return nil
    }
    
}
