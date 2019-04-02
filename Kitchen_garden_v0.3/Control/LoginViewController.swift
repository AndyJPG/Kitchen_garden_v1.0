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
        guard let newUser = UserInfo(name: name, expectTime: 3, useSpace: 10) else {
            fatalError("Unable to creat instains")
        }
        user = [newUser]
        saveUserInfo()
    }

    //MARK: save and load user data
    private func saveUserInfo() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(user, toFile: UserInfo.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("User info successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save user info...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadUser() -> [UserInfo]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: UserInfo.ArchiveURL.path) as? [UserInfo]
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Always have super prepare
        super.prepare(for: segue, sender: sender)
        
        
    }
    
    //MARK: Private method
    private func updateButtonState() {
        let text = nameField.text ?? ""
        explore.isEnabled = !text.isEmpty
        searchPlant.isEnabled = !text.isEmpty
    }
}

