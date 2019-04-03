//
//  Plant.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class Plant {

    //MARK: Properties
    var name: String
    var minSpace: String
    var maxSpace: String
    var minHarvest: String
    var maxHarvest: String
    
    //Initialization
    init(name: String, minSpace: String, maxSpace: String, minHarvest: String, maxHarvest: String){

        //Initialise property
        self.name = name
        self.minSpace = minSpace
        self.maxSpace = maxSpace
        self.minHarvest = minHarvest
        self.maxHarvest = maxHarvest
        
    }
    
}
