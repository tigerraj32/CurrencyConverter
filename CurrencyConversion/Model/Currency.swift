//
//  Currency.swift
//  CurrencyConversion
//
//  Created by javra on 4/12/19.
//  Copyright © 2019 javra. All rights reserved.
//

import Foundation

public struct Currency {
    var code: String
    var country: String
    func title()-> String{
        
        
        let title = self.code + " | " + self.country
        return title
    }
}



