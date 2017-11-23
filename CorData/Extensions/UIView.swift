//
//  UIView.swift
//  CorData
//
//  Created by Lewis Le on 23/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import UIKit

extension UIView {
    
    func addAutoSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

}
