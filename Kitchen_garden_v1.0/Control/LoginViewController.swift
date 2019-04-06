//
//  ViewController.swift
//  Kitchen_garden_v0.3
//
//  Created by Peigeng Jiang on 2/4/19.
//  Copyright © 2019 Peigeng Jiang. All rights reserved.
//

import UIKit
import os.log

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    
    //MARK: Properties
    var user: UserInfo?
    @IBOutlet weak var explore: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var topSquare: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
        
        // Do any additional setup after loading the view.
        if let userInfo = loadUser() {
            user = userInfo[0]
        }
                
//        updateButtonState()
        
        //create to square view
        createView()
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the buttons while editing.
        explore.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonState()
        let name = nameField.text ?? ""
        guard let newUser = UserInfo(name: name, expectTime: ["0", "0"], useSpace: ["0","0"]) else {
            fatalError("Unable to creat instains")
        }
        user = newUser
        saveUserInfo()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Always have super prepare
        super.prepare(for: segue, sender: sender)
        
        guard let nv = segue.destination as? UINavigationController else {
            fatalError("Unexpected sender: \(segue.destination)")
        }
        
        guard let homeVC = nv.topViewController as? HomeTableViewController else {
            fatalError("Unexpected sender: \(String(describing: nv.topViewController))")
        }
        
        homeVC.user = user
        
    }
    
    //MARK: Private method
    private func updateButtonState() {
        let text = nameField.text ?? ""
        explore.isEnabled = !text.isEmpty
    }
    
    //MARK: Private save and load user data
    private func saveUserInfo() {
        let data = try? NSKeyedArchiver.archivedData(withRootObject: [user], requiringSecureCoding: false)
        UserDefaults.standard.set(data, forKey: "user")
    }
    
    private func loadUser() -> [UserInfo]?  {
        guard let data = UserDefaults.standard.data(forKey: "user") else {
            return nil
        }
        return try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [UserInfo]
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
        
        explore.layer.cornerRadius = 20
        explore.backgroundColor = UIColor.init(red: 96/255, green: 186/255, blue: 114/255, alpha: 1.0)
    }
    
    private func uiAlert()  {
        let alert = UIAlertController(title: "Name", message: "Please enter your name before getting start", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exploreTapped(_ sender: Any) {
        explore.backgroundColor = UIColor.init(red: 85/255, green: 168/255, blue: 100/255, alpha: 1.0)
        if nameField.text?.isEmpty ?? true {
            uiAlert()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

