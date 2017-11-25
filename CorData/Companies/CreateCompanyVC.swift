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

class CreateCompanyVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            if let founded = company?.founded {
                datePicker.date = founded
            }
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
        }
    }
    
    var delegate: CreateCompanyControllerDelegate?
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        return imageView
    }()
    
    @objc private func handleSelectPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        setupCircularImageStyle()
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        return dp
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        view.backgroundColor = .darkBlue
        setupCancelButtonInNavBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    private func setupUI() {
        let lightBlueBgView = setupLightBlueBackgroundView(withHeight: 350)
        
        view.addAutoSubview(companyImageView)
        companyImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        companyImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addAutoSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addAutoSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        view.addAutoSubview(datePicker)
        datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        datePicker.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        datePicker.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: lightBlueBgView.bottomAnchor).isActive = true
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
        company?.founded = datePicker.date
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 1)
            company?.imageData = imageData
        }
        
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
        company.setValue(self.datePicker.date, forKey: "founded")
        if let companyImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(companyImage, 1)
            company.setValue(imageData, forKey: "imageData")
        }
        
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





















