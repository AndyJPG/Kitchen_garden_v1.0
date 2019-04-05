//
//  netWork.swift
//  Kitchen_garden_v1.0
//
//  Created by Peigeng Jiang on 5/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class NetworkController {
    
    //Properties
    let plantURL = "http://3.84.249.169/serviceTime.php"
    
    var delegate: UIViewController?
    func fetchDoesCallSucceed() {
        let task = session.dataTask(with: URLRequest) {
            (data, response, error) in
            let success = error == nil
            delegate?.didGetResult(success)
        }
        task.resume()
    }
    
    //MARK: Get json connection
    func parsingJson(completionHandler: @escaping (_ result: [Plant],_ error: Error?) -> Void) {
        
        guard let url = URL(string: plantURL) else {fatalError()}
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                //                print(jsonResponse) //Response result
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)
                
                var jsonPlants = [Plant]()
                //store all plants
                for dic in jsonArray {
                    guard let name = dic["CropName"] as? String else {return}
                    guard let minSpace = dic["Min Space (in cms)"] as? String else {
                        return
                    }
                    guard let maxSpace = dic["Max Space (In cms)"] as? String else {return}
                    guard let minHarvest = dic["Min Harvest time (Weeks)"] as? String else {return}
                    guard let maxHarvest = dic["Max harvest time (Weeks)"] as? String else {return}
                    
                    let newPlant = Plant(name: name, minSpace: minSpace, maxSpace: maxSpace, minHarvest: minHarvest, maxHarvest: maxHarvest)
                    jsonPlants.append(newPlant)
                }
                
                completionHandler(jsonPlants ,nil)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            
        }
        task.resume()
        
    }
}
