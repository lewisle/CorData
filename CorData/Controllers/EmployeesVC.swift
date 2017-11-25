//
//  EmployeesVC.swift
//  CorData
//
//  Created by Lewis Le on 25/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit

class EmployeesVC: UITableViewController {
    
    var company: Company?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = .darkBlue
        setupPlusButtonInNavBar(#selector(handleAddEmployee))
    }
    
    @objc private func handleAddEmployee() {
        let createEmployeeVC = CreateEmployeeVC()
        let navController = UINavigationController(rootViewController: createEmployeeVC)
        present(navController, animated: true, completion: nil)
    }

}
