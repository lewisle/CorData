//
//  EmployeesVC.swift
//  CorData
//
//  Created by Lewis Le on 25/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit
import CoreData

class EmployeesVC: UITableViewController, CreateEmployeeControllerDelegate {
    
    let cellId = "cellId"
    var company: Company?
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEmployees()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(#selector(handleAddEmployee))
    }
    
    private func fetchEmployees() {
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else { return }
        self.employees = companyEmployees
    }
    
    @objc private func handleAddEmployee() {
        let createEmployeeVC = CreateEmployeeVC()
        createEmployeeVC.delegate = self
        createEmployeeVC.company = self.company
        let navController = UINavigationController(rootViewController: createEmployeeVC)
        present(navController, animated: true, completion: nil)
    }
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        
        if let taxId = employee.employeeInfo?.taxId {
            cell.textLabel?.text = "\(employee.name ?? "") \(taxId)"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }

}
