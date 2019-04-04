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

        //read data
        parsingJson()

    }
    
    //MARK: Get json connection
    func parsingJson() {

        guard let url = URL(string: "http://3.84.249.169/serviceTime.php") else {return}

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                print(jsonResponse) //Response result

                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                    return
                }
                print(jsonArray)

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
                    self.plants.append(newPlant)
                }
                
                self.tableView.reloadData()

            } catch let parsingError {
                print("Error", parsingError)
            }

        }
        task.resume()

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
        cell.infoLabel.text = "Space need: \(plant.minSpace) cm - \(plant.maxSpace) cm"
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
        
        
        let selectedPlant = plants[indexPath.row]
        detailVC.plant = selectedPlant
        
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

}

//Search bar extension method
extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
