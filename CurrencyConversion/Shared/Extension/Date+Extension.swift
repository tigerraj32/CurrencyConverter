//
//  Date+Extension.swift
//  CurrencyConversion
//
//  Created by javra on 4/12/19.
//  Copyright © 2019 javra. All rights reserved.
//

import Foundation

let dateFormatter = "yyyy-MM-dd"

extension Date {
    
    
    func today()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date)
    }
    
    func dateToString(date: Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date)
    }
}
