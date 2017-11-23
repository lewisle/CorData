//
//  CreateCompanyVC.swift
//  CorData
//
//  Created by Lewis Le on 23/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(_ company: Company)
    func didEditCompany(_ company: Company)
}

class CreateCompanyVC: UIViewController {
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
        }
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        view.backgroundColor = .darkBlue
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    fileprivate func setupUI() {
        let lightBlueBgView = UIView()
        lightBlueBgView.backgroundColor = .lightBlue
        view.addAutoSubview(lightBlueBgView)
        lightBlueBgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBgView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        company?.name = nameTextField.text
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(self.company!)
            }
        } catch let saveErr {
            print("Failed to save company changes: \(saveErr)")
        }
    }
    
    private func createCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(self.nameTextField.text, forKey: "name")
        
        do {
            try context.save()
            
            self.dismiss(animated: true, completion: {
                self.delegate?.didAddCompany(company as! Company)
            })
        } catch let saveErr {
            print("Failed to save company: \(saveErr)")
        }
    }

}





















