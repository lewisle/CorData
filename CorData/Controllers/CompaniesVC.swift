//
//  ViewController.swift
//  CorData
//
//  Created by Lewis Le on 23/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit
import CoreData

class CompaniesVC: UITableViewController, CreateCompanyControllerDelegate {
    
    let cellId = "cellId"
    var companies = [Company]()
    
    func didAddCompany(_ company: Company) {
        // 1- modify companies array
        companies.append(company)
        
        // 2- insert a new index path into tableView
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    private func fetchCompanies() {
        let persistentContainer = NSPersistentContainer(name: "CorDataModels")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Failed to load store: \(err)")
            }
        }
        
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            try context.fetch(fetchRequest).forEach({ (company) in
                print(company.name ?? "")
            })
        } catch let fetchErr {
            print("Failed to fetch companies: \(fetchErr)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCompanies()
        
        view.backgroundColor = .white
        navigationItem.title = "Companies"
        
        tableView.backgroundColor = .darkBlue
        tableView.separatorColor = .white
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddCompany))
    }
    
    @objc func handleAddCompany() {
        let createCompanyVC = CreateCompanyVC()
        createCompanyVC.delegate = self
        let navController = CustomNavigationController(rootViewController: createCompanyVC)
        
        present(navController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        let company = companies[indexPath.row]
        cell.textLabel?.text = company.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

}

