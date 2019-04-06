//
//  SearchTableViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class SearchTableViewController: UITableViewController, UISearchControllerDelegate {
    
    //MARK: Properties
    var plants = [Plant]()
    var filter: String?
    var user: UserInfo?
    let plantURL = URL(string: "http://3.84.249.169/serviceTime.php")
    
    //properties for search bar
    var filteredPlants = [Plant]()
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Search bar code
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Plant"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //needs to delete
//        filter = "space"
//        user = UserInfo(name: "andy", expectTime: ["0","50"], useSpace: ["0","10"])
        
        //read data
        parsingJson()
        
        while plants.isEmpty {
            tableView.reloadData()
        }

    }
    
    //MARK: Get json connection
    func parsingJson() {
        guard let downLoadUrl = plantURL else {return}
        URLSession.shared.dataTask(with: downLoadUrl) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("connection wrong")
                return
            }
            print("downloaded")
            do
            {
                //get json response
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                //convert to json array
                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                
                for dic in jsonArray {
                    guard let name = dic["CropName"] as? String else {return}
                    guard let minSpace = dic["Min Space (in cms)"] as? String else {return}
                    guard let maxSpace = dic["Max Space (In cms)"] as? String else {return}
                    guard let minHarvest = dic["Min Harvest time (Weeks)"] as? String else {return}
                    guard let maxHarvest = dic["Max harvest time (Weeks)"] as? String else {return}

                    let newPlant = Plant(name: name, minSpace: minSpace, maxSpace: maxSpace, minHarvest: minHarvest, maxHarvest: maxHarvest)
                    
                    if self.filterFromUserInput(plant: newPlant) {
                        self.plants.append(newPlant)
                    }
                }
                
            } catch {
                print("somthing wrong after downloaded")
            }
            
        }.resume()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If filtered only show filtered data
        if isFiltering() {
            return filteredPlants.count
        }
        
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cell Identifier
        let cellIdentifier = "SearchTableViewCell"
        var plant:Plant
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchTableViewCell else {
            fatalError("The dequeued cell is not an instance of SearchTableViewCell.")
        }

        // Configure the cell
        if isFiltering() {
            plant = filteredPlants[indexPath.row]
        } else {
            plant = plants[indexPath.row]
        }
        
        cell.pImage.image = UIImage(named: plant.name)
        cell.nameLabel.text = plant.name
        if plant.minSpace == plant.maxSpace {
            cell.infoLabel.text = "Space need: \(plant.minSpace) cm"
        } else {
            cell.infoLabel.text = "Space need: \(plant.minSpace) cm - \(plant.maxSpace) cm"
        }
        cell.harvestLabel.text = "Harvest Time: \(plant.minHarvest) - \(plant.maxHarvest) Weeks"

        return cell
    }

    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    // Prepare for data transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let detailNV = segue.destination as? UINavigationController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let detailVC = detailNV.topViewController as? DetailViewController else {
            fatalError("Unexpected destination: \(String(describing: detailNV.topViewController))")
        }
        
        guard let selectedPlantCell = sender as? SearchTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedPlantCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        if isFiltering() {
            let selecdPlant = filteredPlants[indexPath.row]
            detailVC.plant = selecdPlant
        } else {
            let selectedPlant = plants[indexPath.row]
            detailVC.plant = selectedPlant
        }
        
    }
    
    //MARK: Search bar update view method
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - Private instance methods for search bar
    private func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPlants = plants.filter({( plant : Plant) -> Bool in
            return plant.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func filterFromUserInput(plant: Plant) -> Bool {
        
        switch filter {
        case "harvestTime":
            let maxHarvest = Int(plant.maxHarvest) ?? 0
            if (maxHarvest >= Int(user?.expectTime[0] ?? "0") ?? 0) && (maxHarvest <= Int(user?.expectTime[1] ?? "0") ?? 0){
                return true
            } else {
                return false
            }
        case "space":
            let maxSpace = Int(plant.maxSpace) ?? 0
            if (maxSpace >= Int(user?.useSpace[0] ?? "0") ?? 0) && (maxSpace <= Int(user?.useSpace[1] ?? "0") ?? 0) {
                return true
            } else {
                return false
            }
        default: break
        }
        
        return true
    }

}

//Search bar extension method
extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
