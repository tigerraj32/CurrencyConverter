//
//  ApplicationPrefrence.swift
//  GoNepalHoliday
//
//  Created by IGC Technologies on 1/22/16.
//  Copyright © 2016 IGC Technologies. All rights reserved.
//

import Foundation

class ApplicationPrefrence {
    
    class func read(key:String) ->AnyObject! {
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    
    class  func save(key:String, object:AnyObject) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func remove(key: String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    class func removeUserDefault() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
    }
    
    class func printUserDefault(){
        print(UserDefaults.standard.dictionaryRepresentation())
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
