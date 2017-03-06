//
//  UserDefaultHelper.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import Foundation

class UserDefaultHelper {
    
    var defaults: UserDefaults = UserDefaults.standard
    
    func saveUserDefault(_ key: String, value : Any){
        defaults.set(value , forKey : key)
        defaults.synchronize()
    }
    
    func getUserDefaultObject(_ key : String) -> Any?{
        return defaults.object(forKey: key)
    }
    
    func getUserDefaultString(_ key : String) ->String?{
        return defaults.object(forKey: key) as! String?
    }
    
    func getUserDefaultInt(_ key : String) ->Int{
        return defaults.integer(forKey: key)
    }
    
    func getUserDefaultBool(_ key : String) ->Bool{
        return defaults.bool(forKey: key)
    }
    
    func getUserDefaultDouble(_ key :  String) ->Double{
        return defaults.double(forKey: key)
    }
    
    func getUserDefaultFloat(_ key :  String) ->Float{
        return defaults.float(forKey: key)
    }
    
    func removeObjectForKey(_ key: String){
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    func isKeyExists(_ key: String) -> Bool {
        return defaults.object(forKey: key) == nil ? false : true
    }
}
