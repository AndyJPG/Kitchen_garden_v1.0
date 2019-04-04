//
//  Plant.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class Plant: NSObject, NSCoding {

    //MARK: Properties
    var name: String
    var minSpace: String
    var maxSpace: String
    var minHarvest: String
    var maxHarvest: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("plants")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let minSpace = "minSpace"
        static let maxSpace = "maxSpace"
        static let minHarvest = "minHarvest"
        static let maxHarvest = "maxHarvest"
    }
    
    //Initialization
    init(name: String, minSpace: String, maxSpace: String, minHarvest: String, maxHarvest: String){

        //Initialise property
        self.name = name
        self.minSpace = minSpace
        self.maxSpace = maxSpace
        self.minHarvest = minHarvest
        self.maxHarvest = maxHarvest
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(minSpace, forKey: PropertyKey.minSpace)
        aCoder.encode(maxSpace, forKey: PropertyKey.maxSpace)
        aCoder.encode(minHarvest, forKey: PropertyKey.minHarvest)
        aCoder.encode(maxHarvest, forKey: PropertyKey.maxHarvest)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let minSpace = aDecoder.decodeObject(forKey: PropertyKey.minSpace) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let maxSpace = aDecoder.decodeObject(forKey: PropertyKey.maxSpace) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let minHarvest = aDecoder.decodeObject(forKey: PropertyKey.minHarvest) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let maxHarvest = aDecoder.decodeObject(forKey: PropertyKey.maxHarvest) as? String else {
            os_log("Unable to decode the name for a User object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, minSpace: minSpace, maxSpace: maxSpace, minHarvest: minHarvest, maxHarvest: maxHarvest)
        
    }
    
}
