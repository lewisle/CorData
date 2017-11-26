//
//  CreateEmployeeVC.swift
//  CorData
//
//  Created by Lewis Le on 25/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeVC: UIViewController {
    
    var company: Company?
    
    var delegate: CreateEmployeeControllerDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        
        navigationItem.title = "Create Employee"
        setupCancelButtonInNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        setupUI()
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = company else { return }
        CoreDataManager.shared.createEmployee(name: employeeName, company: company) { (error, employee) in
            if let err = error {
                // Maybe show a friendly message here
                print(err)
            } else {
                dismiss(animated: true, completion: {
                    self.delegate?.didAddEmployee(employee: employee!)
                })
            }
        }
    }
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(withHeight: 50)
        
        view.addAutoSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addAutoSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
    }

}
