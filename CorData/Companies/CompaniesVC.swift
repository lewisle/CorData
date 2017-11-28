//
//  ViewController.swift
//  CorData
//
//  Created by Lewis Le on 23/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit
import CoreData

class CompaniesVC: UITableViewController {
    
    let cellId = "cellId"
    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
        
        view.backgroundColor = .white
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.title = "Companies"
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)),
            UIBarButtonItem(title: "Do BG", style: .plain, target: self, action: #selector(doNestedUpdates))
        ]
        setupPlusButtonInNavBar(#selector(handleAddCompany))
    }
    
    @objc func doNestedUpdates() {
        DispatchQueue.global(qos: .background).async {
            // First construct a custom MOC
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            // Execute updates on privateContext new
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            
            do {
                let companies = try privateContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "C: \(company.name ?? "")"
                })
                
                do {
                    try privateContext.save()
                    DispatchQueue.main.async {
                        do {
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            if context.hasChanges {
                                try context.save()
                            }
                            self.tableView.reloadData()
                        } catch let finalSaveErr {
                            print("Failed to save on main context: \(finalSaveErr)")
                        }
                    }
                } catch let saveErr {
                    print("Failed to save on private context: \(saveErr)")
                }
            } catch let fetchErr {
                print("Failed to fetch on private context: \(fetchErr)")
            }
        }
    }
    
    @objc func doUpdates() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (bgContext) in
            let request: NSFetchRequest<Company> = Company.fetchRequest()
            
            do {
                let companies = try bgContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "B: \(company.name ?? "")"
                })
                
                do {
                    try bgContext.save()
                    DispatchQueue.main.async {
                        // Reset will forget all of the objects you've fetched before
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let saveErr {
                    print("Failed to save on background: \(saveErr)")
                }
            } catch let err {
                print("Failed to fetch companies on background: \(err)")
            }
        }
    }
    
    @objc func doWork() {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (bgContext) in
            // Background tasks go here...
            (1...50).forEach({ (value) in
                print(value)
                let company = Company(context: bgContext)
                company.name = String(Date().timeIntervalSince1970)
            })
            
            do {
                try bgContext.save()
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Failed to save: \(err)")
            }
        }
    }
    
    @objc func handleReset() {
        CoreDataManager.shared.resetCompanies { (error) in
            if let err = error {
                // maybe show a user-friendly messsage here...
                print(err)
            } else {
                var indexPathsToRemove = [IndexPath]()
                for (index, _) in companies.enumerated() {
                    indexPathsToRemove.append(IndexPath(row: index, section: 0))
                }
                companies.removeAll()
                tableView.deleteRows(at: indexPathsToRemove, with: .left)
            }
        }
    }
    
    @objc func handleAddCompany() {
        let createCompanyVC = CreateCompanyVC()
        createCompanyVC.delegate = self
        let navController = UINavigationController(rootViewController: createCompanyVC)
        
        present(navController, animated: true, completion: nil)
    }

}
