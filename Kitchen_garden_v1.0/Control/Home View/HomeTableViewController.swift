//
//  HomeTableViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    //MARK: Properites
    var user: UserInfo?
    var plants = [Plant]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        
        //Check for persistent data
        if let loadPlants = loadPlants() {
            plants = loadPlants
        }
        
        if let user = user {
             navigationItem.title = "\(user.name)'s Farm"
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            fatalError("Unable getting UItable view cell")
        }
        
        let plant = plants[indexPath.row]
        cell.name.text = plant.name
        cell.plantImage.image = UIImage(named: plant.name)
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            plants.remove(at: indexPath.row)
            savePlants()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nv = segue.destination as? UINavigationController else {
            fatalError("cant get navigation controller")
        }
        
        guard let preferenceVC = nv.topViewController as? PerferenceViewController else {
            fatalError("cant get perference view controller")
        }
        
        preferenceVC.user = user
    }
    
    
    //MARK: Unwind method
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? DetailViewController, let plant = sourceViewController.plant {

            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing plant.
                plants[selectedIndexPath.row] = plant
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new plant.
                let newIndexPath = IndexPath(row: plants.count, section: 0)

                plants.append(plant)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the meals.
            savePlants()
        }
        print("welcome back")
    }
    
    //MARK: Private method
    private func savePlants() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: plants, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "plants")
    }
    
    private func loadPlants() -> [Plant]?  {
        guard let data = UserDefaults.standard.data(forKey: "plants") else {
            return nil
        }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Plant]
    }

}
