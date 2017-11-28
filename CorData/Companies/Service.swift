//
//  Service.swift
//  CorData
//
//  Created by Lewis Le on 28/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    
    static let shared = Service()
    
    private let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func downloadCompaniesFromServer() {
        print("Downloading companies from server...")
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            print("Finished downloading.")
            
            if let err = err {
                print("Failed to download companies: \(err)")
                return
            }
            
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
                
                jsonCompanies.forEach({ (jsonCompany) in
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    let df = DateFormatter()
                    df.dateFormat = "MM/dd/yyyy"
                    company.founded = df.date(from: jsonCompany.founded)
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        let employeeInfo = EmployeeInfo(context: privateContext)
                        let birthdayDate = df.date(from: jsonEmployee.birthday)
                        employeeInfo.birthday = birthdayDate
                        employee.employeeInfo = employeeInfo
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                    } catch let err {
                        print("Failed to save companies: \(err)")
                    }
                })
            } catch let err {
                print("Failed to decode: \(err)")
            }
            
        }.resume()
    }
    
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
