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
    
    //error msgs
    @IBOutlet weak var firstNameErrMsg: UITextView!
    @IBOutlet weak var lastNameErrMsg: UITextView!
    @IBOutlet weak var emailErrMsg: UITextView!
    @IBOutlet weak var pwErrMsg: UITextView!
    
    
    @IBOutlet weak var bottomConstraintPW: NSLayoutConstraint!
    
    var firstNameValidationStatus: Bool = true
    var lastNameValidationStatus: Bool = true
    var emailValidationStatus: Bool = true
    var pwValidationStatus: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPwTextField.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldsValidations(textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        return true
    }
        
    @IBAction func didPressSignUpBtn(_ sender: Any) {
        self.validationsWhenPressSignup()
        //Send the user object to the server and wait for the response
        let params = ["FirstName": firstNameTextField.text,
                      "LastName": lastNameTextField.text,
                      "Email": emailTextField.text,
                      "Password": passwordTextField.text] as! Dictionary<String, String>
        print(params)
        var request = URLRequest(url: URL(string: "http://localhost:8080/signup")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let waitForTaskGroup = DispatchGroup()
        
        waitForTaskGroup.enter()
        let session = URLSession.shared
        //self.showLoadView()
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            //DispatchQueue.main.async{self.dismissLoadView()}
            
            do {
                if error != nil{
                    //handel error
                    print(error!.localizedDescription)
                    self.showAlertMessage(message: "Please check your network connection and try again")
                    return
                }
                
                let response = response as! HTTPURLResponse
                if response.statusCode != 200 {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json["errorMsg"]!)
                    self.showAlertMessage(message: "Something went wrong...\n Please try again later")
                    
                }
                else{
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //need to save/use the relevent data from backend
                    if (json["actionSucceed"] as! Bool){ //if the login at the backend succeeded
                        UserDefaults.standard.set(json["userId"], forKey: "userID")
                        self.doSegue(withIdentifier: "signUpSegue", sender: sender)
                    }
                    else{ //if the login at the backend failed
                        self.showAlertMessage(message: json["errorMsg"]! as! String)
                    }
                }
                

            } catch {
                print("error")
            }
        })
        
        task.resume()
        
    }
    
//    func dismissLoadView(){
//        DispatchQueue.main.async{self.dismiss(animated: false, completion: nil)}
//    }
//
//    func showLoadView(){
//        //test load page
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        present(alert, animated: true)
//    }
    
    func doSegue(withIdentifier identifier: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "signUpSegue", sender: sender)
            //self.shouldPerformSegue(withIdentifier: "signUpSegue", sender: sender)
        }
    }
    
    func showAlertMessage(message:String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "Sign Up Failed", message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertMessage.addAction(cancelAction)
            
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    //validations right when tapping sign up button
    func validationsWhenPressSignup(){
        //verify all fields are not empty
        if (firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == ""  || passwordTextField.text == "" || confirmPwTextField.text == ""){
            let alert = UIAlertController(title: "Invalid Action", message: "At least one of the text field are empty. Please fill all information before submition", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //verify all fields have valid values
        if(firstNameValidationStatus == false || lastNameValidationStatus == false || emailValidationStatus == false || pwValidationStatus == false){
            let alert = UIAlertController(title: "Invalid Action", message: "One or more fields are not valid. Please change information before subbmition", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //verify PW confirmation
        if (passwordTextField.text != confirmPwTextField.text) {
            let alert = UIAlertController(title: "Invalid Action", message: "Your confirmation password is not match to the password field. Please retype and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
    }

    //validations and error handaling for all the text fields
    func textFieldsValidations(_ textField: UITextField){
        switch (textField.tag) {
        case SignUpView.firstNameFieldTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, firstNameTextField.text!))
            switch response {
            case .success:
                firstNameTextField.layer.borderWidth = 1;
                firstNameTextField.layer.borderColor = UIColor.lightGray.cgColor
                firstNameErrMsg.isHidden = true
                firstNameValidationStatus = true
                break
            case .failure(_, let message):
                print(message.localized())
                if (message == AlertMessages.emptyFirstLetterCaps){
                    firstNameErrMsg.text = AlertMessages.emptyFirstLetterCaps.rawValue
                }
                else{
                    firstNameErrMsg.text = "First Letter should be capital, and name contain only letters"
                }
                firstNameTextField.layer.borderWidth = 1;
                firstNameTextField.layer.borderColor = UIColor.red.cgColor
                firstNameErrMsg.isHidden = false
                firstNameValidationStatus = false
            }
            break;
            
        case SignUpView.lastNameFieldTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, lastNameTextField.text!))
            switch response {
            case .success:
                lastNameTextField.layer.borderWidth = 1;
                lastNameTextField.layer.borderColor = UIColor.lightGray.cgColor
                lastNameErrMsg.isHidden = true
                lastNameValidationStatus = true
                break
            case .failure(_, let message):
                print(message.localized())
                if (message == AlertMessages.emptyFirstLetterCaps){
                    lastNameErrMsg.text = AlertMessages.emptyFirstLetterCaps.rawValue
                }
                else{
                    lastNameErrMsg.text = "First Letter should be capital, and name contain only letters"
                }
                lastNameTextField.layer.borderWidth = 1;
                lastNameTextField.layer.borderColor = UIColor.red.cgColor
                lastNameErrMsg.isHidden = false
                lastNameValidationStatus = false
            }
            break;
            
        case SignUpView.emailFieldTag.rawValue:
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
        case SignUpView.pwFieldTag.rawValue:
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
        case SignUpView.confirmPwTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.password, confirmPwTextField.text!))
            switch response {
            case .success:
                if (confirmPwTextField.text! == passwordTextField.text!){
                    confirmPwTextField.layer.borderWidth = 1;
                    confirmPwTextField.layer.borderColor = UIColor.lightGray.cgColor
                    pwErrMsg.isHidden = true
                    break
                }
                else {
                    print("PW is not equivalent!!!!")
                    pwErrMsg.text = "Your confirmation password must match"
                    confirmPwTextField.layer.borderWidth = 1;
                    confirmPwTextField.layer.borderColor = UIColor.red.cgColor
                    pwErrMsg.isHidden = false
                }
            case .failure(_, let message):
                print(message.localized())
                pwErrMsg.text = message.localized()
                confirmPwTextField.layer.borderWidth = 1;
                confirmPwTextField.layer.borderColor = UIColor.red.cgColor
                pwErrMsg.isHidden = false
            }
            break;
        default:
            break;
        }
    }
    
}

