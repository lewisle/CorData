//
//  CoreDataManager.swift
//  CorData
//
//  Created by Lewis Le on 23/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CorDataModels")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Failed to load store: \(err)")
            }
        }
        
        return container
    }()
    
}
