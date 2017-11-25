//
//  UIViewController+Helpers.swift
//  CorData
//
//  Created by Lewis Le on 25/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupPlusButtonInNavBar(_ selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButtonInNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(withHeight height: CGFloat) -> UIView {
        let lightBlueBgView = UIView()
        lightBlueBgView.backgroundColor = .lightBlue
        view.addAutoSubview(lightBlueBgView)
        lightBlueBgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBgView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return lightBlueBgView
    }
}
