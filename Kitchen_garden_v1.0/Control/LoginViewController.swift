//
//  ViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    var user = [UserInfo]()
    @IBOutlet weak var searchPlant: UIButton!
    @IBOutlet weak var explore: UIButton!
    @IBOutlet weak var nameField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
        // Do any additional setup after loading the view.
        if let userInfo = loadUser() {
            user = userInfo
        }
        
        updateButtonState()
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the buttons while editing.
        explore.isEnabled = false
        searchPlant.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        let name = nameField.text ?? ""
        guard let newUser = UserInfo(name: name, expectTime: 3, useSpace: ["0","0"]) else {
            fatalError("Unable to creat instains")
        }
        user = [newUser]
        saveUserInfo()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Always have super prepare
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "goHomePage":
            os_log("Navigate to home page", log: OSLog.default, type: .debug)
            
        case "preferenceSegue":
            guard let perferenceVC = segue.destination as? PerferenceViewController else {
                fatalError("Unexpected sender: \(segue.destination)")
            }
            perferenceVC.user = user[0]
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
        
    }
    
    //MARK: Private method
    private func updateButtonState() {
        let text = nameField.text ?? ""
        explore.isEnabled = !text.isEmpty
        searchPlant.isEnabled = !text.isEmpty
    }
    
    //MARK: Private save and load user data
    private func saveUserInfo() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    private func loadUser() -> [UserInfo]?  {
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            return nil
        }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UserInfo]
    }
}

