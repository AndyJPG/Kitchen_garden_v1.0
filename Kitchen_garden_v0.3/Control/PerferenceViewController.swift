//
//  PerferenceViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class PerferenceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    //MARK: Properties
    @IBOutlet weak var harvestTextField: UITextField!
    @IBOutlet weak var spaceAvailable: UITextField!
    @IBOutlet weak var welcomLable: UILabel!
    
    var user: UserInfo?
    //array for harvest time and space size
    let dateForHarvest:[(brief: String, time: Int )] = [("5-15 Weeks",15),("15-25 Weeks",25),("25-35 Weeks",35),("35-45 Weeks",45),("45-55 Weeks",55),("55-65 Weeks",65),("65-75 Weeks",75)]
    let spaceNumber = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60", "65", "70", "75", "80", "85", "90", "95", "100"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate
        harvestTextField.delegate = self
        spaceAvailable.delegate = self
 
        //Set welcome massage also see if data transfered
        if let user = user {
            welcomLable.text = "Welcome \(user.name)!"
        }
        
        print("User time \(String(describing: user?.name))")
        print("User time \(String(describing: user?.expectTime))")
        print("User space \(String(describing: user?.useSpace[0])) , \(String(describing: user?.useSpace[1]))")
        
        //Create picker view
        createPickerView()
        
    }
    
    //MARK: Create a picker view
    func createPickerView() {
        let pickerView = UIPickerView()
        
        //set delegate
        pickerView.delegate = self
        harvestTextField.inputView = pickerView
        spaceAvailable.inputView = pickerView
        
        //Create picker button
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.doneButtonTapped))
        
        // Add flexible space to move done button to right
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexibleSpace,doneButton], animated: false)
        harvestTextField.inputAccessoryView = toolBar
        spaceAvailable.inputAccessoryView = toolBar
    }
    
    //MARK: Action picker
    //Set number of column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if harvestTextField.isFirstResponder {
            return 1
        } else if spaceAvailable.isFirstResponder {
            return 2
        }
        return 0
    }
    
    //Set number of row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if harvestTextField.isFirstResponder {
            return dateForHarvest.count
        } else if spaceAvailable.isFirstResponder {
            return spaceNumber.count
        }
        return 0
    }
    
    //Set picker title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if harvestTextField.isFirstResponder {
            return dateForHarvest[row].brief
        } else if spaceAvailable.isFirstResponder {
            return spaceNumber[row]
        }
        return nil
    }
    
    //Select a row and assign value to user
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if harvestTextField.isFirstResponder {
            let selectedTime = dateForHarvest[row]
            harvestTextField.text = selectedTime.brief
            user?.expectTime = selectedTime.time
            
        } else if spaceAvailable.isFirstResponder {
            let width =  spaceNumber[pickerView.selectedRow(inComponent: 0)]
            let long = spaceNumber[pickerView.selectedRow(inComponent: 1)]
            spaceAvailable.text =   width + " x " + long
            user?.useSpace = [width, long]
        }
        
    }
    
    //Dismiss picker view
    @objc func doneButtonTapped(){
        harvestTextField.resignFirstResponder()
        spaceAvailable.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning()
    {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: save user data
    private func saveUserInfo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject([user], toFile: UserInfo.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("User info successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save user info...", log: OSLog.default, type: .error)
        }
    }

}
