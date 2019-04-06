//
//  PerferenceViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class PerferenceViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationBarDelegate, UIAlertViewDelegate {

    //MARK: Properties
    @IBOutlet weak var searchOptions: UITextField!
    @IBOutlet weak var optionInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var topSquare: UIView!
    
    var user: UserInfo?
    //array for harvest time and space size
//    let dateForHarvest:[(brief: String, time: Int )] = [("5-15 Weeks",15),("15-25 Weeks",25),("25-35 Weeks",35),("35-45 Weeks",45),("45-55 Weeks",55),("55-65 Weeks",65),("65-75 Weeks",75)]
    var spaceNumber = [["min"],["0"],["max"],["0"]]
    let options = ["By harvest time (weeks)", "By available spacing (cm)", "View All Plants"]
    var optionID: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate
        searchOptions.delegate = self
        optionInput.delegate = self
        
        //Set space number picker row
        var index = 5
        while index <= 100 {
            spaceNumber[1].append(String(index))
            spaceNumber[3].append(String(index))
            index += 5
        }
        
        
//        navigationItem.leftBarButtonItem?.setBackgroundImage(UIImage(named: "back"), for: .normal, barMetrics: .default)
        
//        user = UserInfo(name: "Andy", expectTime: ["0", "0"], useSpace: ["0", "0"])
        
        //update state
        searchButtonState()
        
        //hidden options
        updateHiddenOption()
        
        //Create picker view
        createPickerView()
        
        //create view
        createView()
        
        updateNVBarUI()
        
        updateButtonColor(bool: false)
        
    }
    
    //MARK: Create a picker view
    func createPickerView() {
        let pickerView = UIPickerView()
        
        //set delegate
        pickerView.delegate = self
        searchOptions.inputView = pickerView
        optionInput.inputView = pickerView
        
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
        
        searchOptions.inputAccessoryView = toolBar
        optionInput.inputAccessoryView = toolBar
    }
    
    //MARK: Action picker
    //Set number of column
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if searchOptions.isFirstResponder {
            return 1
        } else if optionInput.isFirstResponder {
            return 4
        }
        return 0
    }
    
    //Set number of row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if searchOptions.isFirstResponder {
            return options.count
        } else if optionInput.isFirstResponder {
            return spaceNumber[component].count
        }
        return 0
    }
    
    //Set picker title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if searchOptions.isFirstResponder {
            return options[row]
        } else if optionInput.isFirstResponder {
            return spaceNumber[component][row]
        }
        return nil
    }
    
    //Select a row and assign value to user
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if searchOptions.isFirstResponder {
            
            let selectedOption = options[row]
            optionID = row
            searchOptions.text = selectedOption
            
        } else if optionInput.isFirstResponder {
            
            if searchOptions.text == "By harvest time (weeks)" {
                let minDate = spaceNumber[1][pickerView.selectedRow(inComponent: 1)]
                let maxDate = spaceNumber[3][pickerView.selectedRow(inComponent: 3)]
                optionInput.text = "\(minDate) - \(maxDate) Weeks"
                user?.expectTime = [minDate, maxDate]
            } else {
                let minSpace =  spaceNumber[1][pickerView.selectedRow(inComponent: 1)]
                let maxSpace = spaceNumber[3][pickerView.selectedRow(inComponent: 3)]
                optionInput.text = "\(minSpace) - \(maxSpace) cm"
                user?.useSpace = [minSpace, maxSpace]
            }
            
        }
        
    }
    
    
    //Dismiss picker view
    @objc func doneButtonTapped(){
        if searchOptions.isFirstResponder {
            searchOptions.resignFirstResponder()
        } else {
            if (searchOptions.text == "By harvest time (weeks)") {
                if (Int(user?.expectTime[0] ?? "0") ?? 0 >= Int(user?.expectTime[1] ?? "0") ?? 0) {
                    optionInput.text = ""
                    uiAlert()
                }
            } else if (searchOptions.text == "By available spacing (cm)") {
                if (Int(user?.useSpace[0] ?? "0") ?? 0 >= Int(user?.useSpace[1] ?? "0") ?? 0) {
                    optionInput.text = ""
                    uiAlert()
                }
            }
            searchButtonState()
            optionInput.resignFirstResponder()
        }
        updateHiddenOption()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning()
    {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }
    
    //MARK: Text field method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchOptions.isFirstResponder {
            optionInput.isEnabled = false
            optionInput.text = ""
        } else {
            searchOptions.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchOptions.text != "View All Plants" {
            searchOptions.isEnabled = true
            optionInput.isEnabled = true
        }
        searchButtonState()
    }
    
    //MARK: Search button state
    private func searchButtonState()  {
        if searchOptions.text == "View All Plants" {
            updateButtonColor(bool: true)
            searchButton.isEnabled = true
        } else if (searchOptions.text?.isEmpty ?? true) || (optionInput.text?.isEmpty ?? true) {
            updateButtonColor(bool: false)
            searchButton.isEnabled = false
        } else {
            updateButtonColor(bool: true)
            searchButton.isEnabled = true
        }
    }
    
    private func updateButtonColor (bool: Bool) {
        if bool {
            searchButton.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        } else {
            searchButton.backgroundColor = UIColor.lightGray
                //UIColor.init(red: 49.0/255.0, green: 49.0/255.0, blue: 49.0/255.0, alpha: 1.0)
        }
    }
    
    private func updateHiddenOption() {
        optionLabel.isHidden = true
        optionInput.isHidden = true
        
        let option = searchOptions.text
        //updatae hidden option
        switch option {
        case "By harvest time (weeks)":
            optionLabel.text = "Choose expected harvest time"
            optionInput.placeholder = "pick expected harvest time"
            optionLabel.isHidden = false
            optionInput.isHidden = false
        case "By available spacing (cm)":
            optionLabel.text = "Choose available space size"
            optionInput.placeholder = "pick available space size"
            optionLabel.isHidden = false
            optionInput.isHidden = false
        default:
            optionLabel.isHidden = true
            optionInput.isHidden = true
        }
    }
    

    
    
    // MARK: - Navigation
     @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
     }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //pass massage
        guard let nv = segue.destination as? UINavigationController else {
            fatalError("cant get navigation controller")
        }
        
        guard  let searchVC = nv.topViewController as? SearchTableViewController else {
            fatalError("Cant reach search table view controller")
        }
        
        searchVC.user = user
        
        let filter = searchOptions.text
        switch filter {
        case "By harvest time (weeks)":
            searchVC.filter = "harvestTime"
        case "By available spacing (cm)":
            searchVC.filter = "space"
        default:
            searchVC.filter = "all"
        }
        
    }
    
    
    //MARK: save user data
    private func saveUserInfo() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: [user], requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    private func uiAlert()  {
        let alert = UIAlertController(title: "Wrong input", message: "Minimum number can not be smaller than or equal to maximum number", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Ui view sqaure design
    func createView() {
        
        topSquare.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        topSquare.layer.shadowColor = UIColor.black.cgColor
        topSquare.layer.shadowOpacity = 0.4
        topSquare.layer.shadowOffset = CGSize.zero
        topSquare.layer.shadowRadius = 5
        
        topSquare.layer.shadowPath = UIBezierPath(rect: topSquare.bounds).cgPath
        topSquare.layer.shouldRasterize = true
        
        topSquare.layer.cornerRadius = 25
        topSquare.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        //        topSquare.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        //        topSquare.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //
        //        topSquare.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        //        topSquare.heightAnchor.constraint(equalToConstant: view.frame.height/2.3).isActive = true
        
        searchButton.layer.cornerRadius = 20
        searchButton.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
    }
    
    private func updateNVBarUI() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    //set status bar to white
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    //set status bar to white for story board with navigation bar
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }

}
