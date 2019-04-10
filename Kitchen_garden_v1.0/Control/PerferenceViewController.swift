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
    @IBOutlet weak var dropdown: UIImageView!
    
    var user: UserInfo?
    //for picker
    let picker = UIPickerView()
    var activeTextField = 0
    
    var numbers = [["min"],["0"],["max"],["0"]]
    let options = ["By harvest time (weeks)", "By available spacing (cm)", "View All Plants"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegate
        searchOptions.delegate = self
        optionInput.delegate = self
                
        //Set space number picker row
        var index = 5
        while index <= 100 {
            numbers[1].append(String(index))
            numbers[3].append(String(index))
            index += 5
        }
        
        //update state
        searchButtonState()
        
        //hidden options
        updateHiddenOption()
        
        //create view
        createView()
        
        updateNVBarUI()
        
        updateButtonColor(bool: false)
        
        //picker view
        createPickerView()
        createToolbar()
        
    }
    
    //MARK: Create a picker view
    func createPickerView() {
        picker.delegate = self
        picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        searchOptions.inputView = picker
        optionInput.inputView = picker
    }
    
    //Create tool bar
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PerferenceViewController.closePickerView))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        searchOptions.inputAccessoryView = toolbar
        optionInput.inputAccessoryView = toolbar
    }
    
    @objc func closePickerView()
    {
        view.endEditing(true)
    }
    
    //picker columns
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch activeTextField {
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    //picker row number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch activeTextField {
        case 1:
            return options.count
        case 2:
            return numbers[component].count
        default:
            return 0
        }
    }
    
    //picker display title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        switch activeTextField {
        case 1:
            return options[row]
        case 2:
            return numbers[component][row]
        default:
            return options[row]
        }
    }
    
    //MARK: Action picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch activeTextField {
        case 1:
            searchOptions.text = options[row]
            updateHiddenOption()
            searchButtonState()
        case 2:
            let select1 = numbers[1][pickerView.selectedRow(inComponent: 1)]
            let select2 = numbers[3][pickerView.selectedRow(inComponent: 3)]
            if searchOptions.text == options[0] {
                optionInput.text = "\(select1) - \(select2) Weeks"
                user?.expectTime = [select1, select2]
                searchButtonState()
            } else {
                optionInput.text = "\(select1) cm - \(select2) cm"
                user?.useSpace = [select1, select2]
                searchButtonState()
            }
        default:
            
            searchOptions.text = options[row]
            let select1 = numbers[1][row]
            let select2 = numbers[3][row]

            switch searchOptions.text {
            case options[0]:
                optionInput.text = "\(select1) - \(select2) Weeks"
                user?.expectTime = [select1, select2]
            case options[1]:
                optionInput.text = "\(select1) cm - \(select2) cm"
                user?.useSpace = [select1, select2]
            default: break
            }
            
            updateHiddenOption()
            searchButtonState()
            
            break
        }
    }
    
    //MARK: Text field method
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case searchOptions:
            activeTextField = 1
            optionInput.text = ""
            picker.reloadAllComponents()
        case optionInput:
            activeTextField = 2
            picker.reloadAllComponents()
        default:
            activeTextField = 0
        }
    }
    
    
    //MARK: Search button state
    private func searchButtonState()  {
        if searchOptions.text == options[2] {
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
        }
    }
    
    private func updateHiddenOption() {
//        optionLabel.isHidden = true
//        optionInput.isHidden = true
//
//
        let option = searchOptions.text
        //updatae hidden option
        switch option {
        case options[0]:
            optionLabel.text = "Choose expected harvest time"
            optionInput.placeholder = "pick expected harvest time"
            optionLabel.isHidden = false
            optionInput.isHidden = false
            dropdown.isHidden = false
        case options[1]:
            optionLabel.text = "Choose available space size"
            optionInput.placeholder = "pick available space size"
            optionLabel.isHidden = false
            optionInput.isHidden = false
            dropdown.isHidden = false
        default:
            optionLabel.isHidden = true
            optionInput.isHidden = true
            dropdown.isHidden = true
        }
    }
    
    
    // MARK: - Navigation
     @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
     }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let minHarvest = Int(user?.expectTime[0] ?? "0") else {fatalError("cant change min harvest to int")}
        guard let maxHarvest = Int(user?.expectTime[1] ?? "0") else {fatalError("cant change max harvest to int")}
        guard let minSpacing = Int(user?.useSpace[0] ?? "0") else {fatalError("cant change max harvest to int")}
        guard let maxSpacing = Int(user?.useSpace[1] ?? "0") else {fatalError("cant change max harvest to int")}
        
        if minHarvest >= maxHarvest && searchOptions.text == options[0] {
            uiAlert()
        } else if minSpacing >= maxSpacing && searchOptions.text == options[1] {
            uiAlert()
        } else {
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
            case options[0]:
                searchVC.filter = "harvestTime"
            case options[1]:
                searchVC.filter = "space"
            default:
                searchVC.filter = "all"
            }
        }
        
    }
    
    
    //MARK: save user data
    private func saveUserInfo() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: [user], requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    private func uiAlert()  {
        let alert = UIAlertController(title: "Error", message: "Minimum number can not be smaller than or equal to maximum number", preferredStyle: UIAlertController.Style.alert)
        
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
        
        //Create background pictrue
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    private func updateNVBarUI() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
    }

}
