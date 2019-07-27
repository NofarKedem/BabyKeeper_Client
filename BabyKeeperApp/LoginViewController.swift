//
//  LoginViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 17/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation
import UIKit
//import Firebase

class LoginViewController: UIViewController {
 
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordTextField.text = "Password"
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        print("adi")
        
        
    }

    
    
}
