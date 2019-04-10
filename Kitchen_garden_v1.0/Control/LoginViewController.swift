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
    @IBOutlet weak var welcomLabel: UILabel!
    

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
        enableTapAway()
        
        //Create background pictrue
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
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
        if nameField.text?.isEmpty == false {
            let name = nameField.text ?? ""
            guard let newUser = UserInfo(name: name, expectTime: ["0", "0"], useSpace: ["0","0"]) else {
                fatalError("Unable to creat instains")
            }
            user = newUser
            saveUserInfo()
        }
        
        explore.isEnabled = true
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
    
    //MARK: Skip button
    @IBAction func skipButton(_ sender: Any) {
        if user == nil {
            user = UserInfo(name: "Your", expectTime: ["0","0"], useSpace: ["0","0"])
        }
        performSegue(withIdentifier: "goHomePage", sender: self)
    }
    
    
    //MARK: Private method
//    private func updateButtonState() {
//        let text = nameField.text ?? ""
//        explore.isEnabled = !text.isEmpty
//    }
    
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
        explore.titleLabel?.adjustsFontSizeToFitWidth = true
        welcomLabel.adjustsFontSizeToFitWidth = true
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
    
    private func uiAlert(_ alertCase: Int)  {
        var alert = UIAlertController()
        
        switch alertCase {
        case 0:
        alert = UIAlertController(title: "Error", message: "Please enter your name before we start", preferredStyle: UIAlertController.Style.alert)
        case 1:
            alert = UIAlertController(title: "Error", message: "Name can only have characters or number", preferredStyle: UIAlertController.Style.alert)
        default: break
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func exploreTapped(_ sender: Any) {
        guard let name = nameField.text as String? else {fatalError("can not convert")}
        if nameField.text?.isEmpty ?? true {
            uiAlert(0)
        } else if name.rangeOfCharacter(from: CharacterSet.letters) == nil || name.rangeOfCharacter(from: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_ ")) == nil {
            uiAlert(1)
        }
    }
    
    private func enableTapAway() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

