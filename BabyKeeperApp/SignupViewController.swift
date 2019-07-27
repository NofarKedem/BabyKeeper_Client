//
//  SignupViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 20/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation
import UIKit

class SignupViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPwTextField: UITextField!
    @IBOutlet weak var SignUpBtn: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPwTextField.delegate = self
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Editing ended")
        
        switch (textField.tag) {
        case 0:
            print("I'm in 0")
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, firstNameTextField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
            }
            break;
        case 2:
            // do something with this text field
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, firstNameTextField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
            }
            break;
            // remainder of switch statement....
        default:
            break;
        }
    }

        
    @IBAction func didPressSignUpBtn(_ sender: Any) {
        
        let tempFirstName : String = firstNameTextField.text!
        let tempLastName : String = lastNameTextField.text!
        let tempEmail : String = emailTextField.text!
        let tempPW : String = passwordTextField.text!
        var newUser : User = User(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, pw: passwordTextField.text!, myPhoneNum: "")
        
        
        
       
        //Send the user object to the server and wait for the response
        let params = ["FirstName": newUser.firstName,
                      "LastName": newUser.lastName,
                      "Email": newUser.email,
                      "Password": newUser.pw] as Dictionary<String, String>
        print(params)
        var request = URLRequest(url: URL(string: "http://localhost:8080/goodbye")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                //print(json["FaultId"]!)

            } catch {
                print("error")
            }
        })

        task.resume()
        
    }

    
}

