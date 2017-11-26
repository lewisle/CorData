//
//  EmployeesVC.swift
//  CorData
//
//  Created by Lewis Le on 25/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
    
}

class EmployeesVC: UITableViewController, CreateEmployeeControllerDelegate {
    
    let cellId = "cellId"
    var company: Company?
    
    var employees = [Employee]()
    var shortNameEmployees = [Employee]()
    var longNameEmployees = [Employee]()
    var reallyLongNameEmployees = [Employee]()
    var allEmployees = [[Employee]]()
    
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
        
        shortNameEmployees = companyEmployees.filter { (employee) -> Bool in
            guard let count = employee.name?.count else { return false }
            return count < 6
        }
        longNameEmployees = companyEmployees.filter { (employee) -> Bool in
            guard let count = employee.name?.count else { return false }
            return count >= 6 && count <= 9
        }
        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
            guard let count = employee.name?.count else { return false }
            return count > 10
        })
        allEmployees = [
            shortNameEmployees,
            longNameEmployees,
            reallyLongNameEmployees
        ]
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        if section == 0 {
            label.text = "SHORT NAMES"
        } else if section == 1 {
            label.text = "LONG NAMES"
        } else {
            label.text = "REALLY LONG NAMES"
        }
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInfo?.birthday {
            let df = DateFormatter()
            df.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "") / \(df.string(from: birthday))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }

}
