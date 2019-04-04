//
//  SearchTableViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log
import SQLite3

class SearchTableViewController: UITableViewController, UISearchControllerDelegate {
    
    //MARK: Properties
    var plants = [Plant]()
    var plantDB: OpaquePointer?
    
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

        //Loading the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("plant.tbd")
        
        //Opening database
        if sqlite3_open(fileURL.path, &plantDB) != SQLITE_OK {
            print("error opening database")
        }
        
        //read data
        readValues()
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
        
        cell.nameLabel.text = plant.name
        cell.infoLabel.text = "Space need: \(plant.minSpace) cm - \(plant.maxSpace) cm"
        cell.harvestLabel.text = "Harvest Time: \(plant.minHarvest) - \(plant.maxHarvest) Weeks"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let detailVC = segue.destination as? DetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
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
    
    
    //MARK: Private method
    private func readValues() {
        
        //first empty the list of heroes
        plants.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM plant"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(plantDB, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(plantDB)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let name = String(cString: sqlite3_column_text(stmt, 0))
            let minSpace = String(cString: sqlite3_column_text(stmt, 1))
            let maxSpace = String(cString: sqlite3_column_text(stmt, 2))
            let minHarvestTime = String(cString: sqlite3_column_text(stmt, 3))
            let maxHarvestTime = String(cString: sqlite3_column_text(stmt, 4))
            
            //adding values to list
            plants.append(Plant(name: name, minSpace: minSpace, maxSpace: maxSpace, minHarvest: minHarvestTime, maxHarvest: maxHarvestTime))
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

}

//Search bar extension method
extension SearchTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
