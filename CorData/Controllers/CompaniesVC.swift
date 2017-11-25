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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        setupPlusButtonInNavBar(#selector(handleAddCompany))
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
