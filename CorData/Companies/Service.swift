//
//  Service.swift
//  CorData
//
//  Created by Lewis Le on 28/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import Foundation

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
                jsonCompanies.forEach({ (company) in
                    print(company.name)
                    company.employees?.forEach({ (employee) in
                        print("    \(employee.name)")
                    })
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
