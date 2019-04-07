//
//  DetailViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 4/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    var plant: Plant?
    var collection = [String]()
    var cellColor = [UIColor]()
    var cellIcon = [String]()
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        formPage()
        setNavigationBar()
    }
    
    //MARK: Form detail page information
    func formPage() {
        //Uplate imformation
        if let plant = plant {
            //add attribute
            nameLable.text = plant.name
            let space = "Plant Spacing\n\(plant.minSpace) cm - \(plant.maxSpace) cm"
            let harvestTime = "Harvest time\n\(plant.minHarvest) - \(plant.maxHarvest) Weeks"
            collection = [space, harvestTime]
            
            //add color
            let color1 = UIColor.init(red: 254/255, green: 127/255, blue: 45/255, alpha: 1.0)
            let color2 = UIColor.init(red: 87/255, green: 156/255, blue: 135/255, alpha: 1.0)
            cellColor = [color1, color2]
            
            //add image
            cellIcon = ["space","harvest"]
            plantImage.image = UIImage(named: plant.name)
        }
    }
    
    //MARK: Collection view delegate function
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collection.count
    }
    
     // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseCell = "cell"
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath as IndexPath) as! DetailCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.label.text = collection[indexPath.row]
        cell.label.textColor = UIColor.white
        
        //customise cell shape
        cell.backgroundColor = cellColor[indexPath.row] // make cell more visible in our example project
        cell.icon.image = UIImage(named: cellIcon[indexPath.row])
        
        return cell
    }
    
    //MARK: custom collection cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2
        return CGSize(width: width, height: width)
    }
    
    //Set up line spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //Set up interItem spacing
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    

    // MARK: - Navigation
     
    @IBAction func cancel(_ sender: Any) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller when save button is pressed
        guard let button = sender as? UIBarButtonItem, button === addButton else {
            os_log("The button was not pressed", log: OSLog.default, type: .debug)
            return
        }
    }
    
    //MARK: UI
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        
        //set background image
        let bImage = UIImageView()
        bImage.image = UIImage(named: "background")
        bImage.contentMode = .scaleAspectFill
        collectionView.backgroundView = bImage
    }
    
}
