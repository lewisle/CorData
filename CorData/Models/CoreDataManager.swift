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
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return companies
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
            return []
        }
    }
    
    func resetCompanies(completion: (_ error: Error?) -> ()) {
        let context = persistentContainer.viewContext
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(batchDeleteRequest)
            completion(nil)
        } catch let delErr {
            print("Failed to batch delete companies: \(delErr)")
            completion(delErr)
        }
    }
    
    func createEmployee(name: String, completion: (_ error: Error?) -> ()) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        employee.setValue(name, forKey: "name")
        
        do {
            try context.save()
            completion(nil)
        } catch let err {
            print("Failed to create employee: \(err)")
            completion(err)
        }
    }
    
}
