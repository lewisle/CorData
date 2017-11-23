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
    
    private func fetchCompanies() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            self.companies = companies
            self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            let company = self.companies[indexPath.row]
            // Remove company from tableView
            self.companies.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            // Remove company from CoreData
            let context = CoreDataManager.shared.persistentContainer.viewContext
            context.delete(company)
            do {
                try context.save()
            } catch let deleteErr {
                print("Failed to delete company: \(deleteErr)")
            }
        }
        deleteAction.backgroundColor = .lightRed
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
        editAction.backgroundColor = .darkBlue
        
        return [deleteAction, editAction]
    }
    
    func didAddCompany(_ company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditCompany(_ company: Company) {
        if let row = companies.index(of: company) {
            let reloadIndexPath = IndexPath(row: row, section: 0)
            tableView.reloadRows(at: [reloadIndexPath], with: .middle)
        }
    }
    
    fileprivate func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
        let editCompanyVC = CreateCompanyVC()
        editCompanyVC.delegate = self
        editCompanyVC.company = companies[indexPath.row]
        let navController = CustomNavigationController(rootViewController: editCompanyVC)
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
        if let name = company.name, let founded = company.founded {
            let df = DateFormatter()
            df.dateFormat = "MMM dd, yyyy"
            let foundedDate = df.string(from: founded)
            cell.textLabel?.text = "\(name) - Founded: \(foundedDate)"
        } else {
            cell.textLabel?.text = company.name
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

}

