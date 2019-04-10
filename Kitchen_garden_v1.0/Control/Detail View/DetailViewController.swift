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
    var displayButton = true
    var collection = [String]()
    var cellColor = [UIColor]()
    var cellIcon = [String]()
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var detailBackground: UIView!
    @IBOutlet weak var addToMyFarm: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        formPage()
        setNavigationBar()
        setPageUI()
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
        cell.label.textColor = UIColor.init(red: 252/255, green: 102/255, blue: 0/255, alpha: 1.0)
        cell.label.sizeToFit()
        
        //customise cell shape
        cell.icon.image = UIImage(named: cellIcon[indexPath.row])
        
        return cell
    }
    
    //MARK: custom collection cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 2 - 40
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
        uiAlert(indexPath.item)
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
    
    //Perfrom adding plant
    @IBAction func addPlant(_ sender: Any) {
        uiAlert(2)
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    //Prepare for data passing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller when save button is pressed
        guard let button = sender as? UIButton, button === addToMyFarm else {
            os_log("The button was not pressed", log: OSLog.default, type: .debug)
            return
        }
    }
    
    //MARK: Ui alert message
    private func uiAlert(_ alertCase: Int) {
        guard let name = plant?.name else {fatalError("cant find plant name")}
        var alert = UIAlertController()
        
        switch alertCase {
        case 0:
            guard let minSpace = plant?.minSpace else {fatalError("cant convert min space")}
            guard let maxSpace = plant?.maxSpace else {fatalError("cant convert max space")}
            alert = UIAlertController(title: "Plant spacing", message: "\(name) requires minimum spacing of \(minSpace) cm to maximum \(maxSpace) cm between each plant.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            present(alert, animated: true, completion: nil)
        case 1:
            guard let minHarvest = plant?.minHarvest else {fatalError("cant convert min harvest")}
            guard let maxHarvest = plant?.maxHarvest else {fatalError("cant convert max harvest")}
            alert = UIAlertController(title: "Haverst time", message: "\(name) will take between \(minHarvest) and \(maxHarvest) weeks to harvest.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            present(alert, animated: true, completion: nil)
        case 2:
            alert = UIAlertController(title: "\(name) added", message: "You have added a new plant", preferredStyle: .alert)
            
            present(alert, animated: true, completion: nil)
            // change to desired number of seconds (in this case 2 seconds)
            let when = DispatchTime.now() + 1.5
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        default: break
        }
        
    }
    
    //MARK: UI
    private func setNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    private func setPageUI() {
        plantImage.layer.cornerRadius = 20
        detailBackground.layer.cornerRadius = 20
        addToMyFarm.layer.cornerRadius = 20
        addToMyFarm.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        detailBackground.layer.shadowColor = UIColor.black.cgColor
        detailBackground.layer.shadowOpacity = 0.4
        detailBackground.layer.shadowOffset = CGSize.zero
        detailBackground.layer.shadowRadius = 4
        
        if !displayButton {
            addToMyFarm.isHidden = true
            detailBackground.bottomAnchor.constraint(equalTo: detailBackground.bottomAnchor, constant: +60).isActive = true
        }
    }
    
}
