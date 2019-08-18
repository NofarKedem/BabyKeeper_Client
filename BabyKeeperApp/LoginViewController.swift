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

class LoginViewController: UIViewController, UITextFieldDelegate {
 
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrMsg: UITextView!
    @IBOutlet weak var pwErrMsg: UITextView!
    
    var emailValidationStatus: Bool = true
    var pwValidationStatus: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldsValidations(textField) //do we want to perform this validation here? Or just send whatever we got and get a failure anyway from the backend
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func didPressLoginButton(_ sender: UIButton) {
        
        //verify all fields are not empty
        if (emailTextField.text == ""  || passwordTextField.text == ""){
            let alert = UIAlertController(title: "Invalid Action", message: "At least one of the text field are empty. Please fill all information before submition", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //send request to the backend
        let params = ["Email": emailTextField!.text,
                      "Password": passwordTextField!.text] as! Dictionary<String, String>
        
        print(params)
        var request = URLRequest(url: URL(string: "http://localhost:8080/login")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                //print(response!)
                let response = response as! HTTPURLResponse
                if response.statusCode != 200 {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //print(json["message"]!)
                    self.showAlertMessage(message: json["errorMsg"]! as! String)
                    
                }
                else{
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //print(json)
                    //print(json["email"]!)
                    
                    //need to save/use the relevent data from backend
                    if (json["actionSucceed"] as! Bool){ //if the login at the backend succeeded
                        UserDefaults.standard.set(json["userId"], forKey: "userID")
                        self.doSegue(withIdentifier: "loginSegue", sender: sender)
                    }
                    else{ //if the login at the backend failed
                        self.showAlertMessage(message: json["errorMsg"]! as! String)
                    }
                    
                    
                    self.doSegue(withIdentifier: "loginSegue", sender: sender)
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func doSegue(withIdentifier identifier: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: sender)
        }
    }
    
    func showAlertMessage(message:String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertMessage.addAction(cancelAction)
            
            self.present(alertMessage, animated: true, completion: nil)
        }
    }

    //validations and error handaling for all the  login text fields
    func textFieldsValidations(_ textField: UITextField){
        switch (textField.tag) {
        case LoginView.emailFieldTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.email, emailTextField.text!))
            switch response {
            case .success:
                emailTextField.layer.borderWidth = 1;
                emailTextField.layer.borderColor = UIColor.lightGray.cgColor
                emailErrMsg.isHidden = true
                emailValidationStatus = true
                break
            case .failure(_, let message):
                emailErrMsg.text = message.localized()
                emailTextField.layer.borderWidth = 1;
                emailTextField.layer.borderColor = UIColor.red.cgColor
                emailErrMsg.isHidden = false
                emailValidationStatus = false
            }
            break;
        case LoginView.pwFieldTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.password, passwordTextField.text!))
            switch response {
            case .success:
                passwordTextField.layer.borderWidth = 1;
                passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
                pwErrMsg.isHidden = true
                pwValidationStatus = true
                break
            case .failure(_, let message):
                pwErrMsg.text = message.localized()
                passwordTextField.layer.borderWidth = 1;
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                pwErrMsg.isHidden = false
                pwValidationStatus = false
            }
            break;
        default:
            break;
        }
    }
    
}
