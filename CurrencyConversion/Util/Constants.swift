//
//  Constants.swift
//  CurrencyConversion
//
//  Created by javra on 4/11/19.
//  Copyright © 2019 javra. All rights reserved.
//

import Foundation


struct EnviromentalVariable {
    #if DEBUG
     //test
        static let access_token = "635de2760363fbadb5e4c4156406175f"
    #else
     //production
        static let access_token = "635de2760363fbadb5e4c4156406175f"
    #endif
}

struct Constant {
    
    struct URL {
        #if DEBUG
        //teststatic
        static let baseURL = "http://apilayer.net/api/"
        
        #else
        //production
        static let baseURL = "http://apilayer.net/api"
        
        #endif
        
         static let live = baseURL +  "live"
         static let history = baseURL + "history"
         static  let cacheInterval = 1800.0 // 30 minutes in seconds
    }
    
    struct String {
        static let expiresOn = "expiresOn"
        static let quotes = "quotes"
    }
   
    
    
}
