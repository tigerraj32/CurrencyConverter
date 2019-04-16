//
//  Currencies.swift
//  CurrencyConversion
//
//  Created by javra on 4/12/19.
//  Copyright © 2019 javra. All rights reserved.
//

import Foundation

class Currencies: NSObject {
    static let shared: Currencies = Currencies()
    var items: [String: String] {
        if let path = Bundle.main.path(forResource: "Currency", ofType: ".plist") {
            return (NSDictionary(contentsOfFile: path) as? [String: String])!
        }
        return [:]
    }
}
