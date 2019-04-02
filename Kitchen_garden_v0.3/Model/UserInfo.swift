//
//  UserInfo.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class UserInfo: NSObject, NSCoding {
    
    //Properties
    var name: String
    var expectTime: Int
    var useSpace: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("user")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let expectTime = "expectTime"
        static let useSpace = "useSpace"
    }
    
    //MARK: Inilialization
    init?(name: String, expectTime: Int, useSpace: Int) {
        //set up for user name
        guard !name.isEmpty else {
            return nil
        }
        
        //expect time must between 3 to 100 weeks
        guard (expectTime >= 3) && (expectTime <= 100) else {
            return nil
        }
        
        //use space must between 10 to 250
        guard (useSpace >= 10) && (useSpace <= 250) else {
            return nil
        }
        
        self.name = name
        self.expectTime = expectTime
        self.useSpace = useSpace
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(expectTime, forKey: PropertyKey.expectTime)
        aCoder.encode(useSpace, forKey: PropertyKey.useSpace)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let expectTime = aDecoder.decodeInteger(forKey: PropertyKey.expectTime)
        let useSpace = aDecoder.decodeInteger(forKey: PropertyKey.useSpace)
        
        // Must call designated initializer.
        self.init(name: name, expectTime: expectTime, useSpace: useSpace)
        
    }
    
}
