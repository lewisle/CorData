//
//  CustomMigrationPolicy.swift
//  CorData
//
//  Created by Lewis Le on 28/11/2017.
//  Copyright © 2017 Lewis Le. All rights reserved.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {
    
    @objc func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
