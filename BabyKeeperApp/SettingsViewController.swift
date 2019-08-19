//
//  SettingsViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 06/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//
import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fNaneField: UILabel!
    @IBOutlet weak var lNameField: UILabel!
    @IBOutlet weak var phoneNumField: UITextField!
    @IBOutlet weak var contactFirstNameField: UITextField!
    @IBOutlet weak var contactLastNameField: UITextField!
    @IBOutlet weak var contactPhoneField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var editPhoneBtn: UIButton!
    @IBOutlet weak var approvePhoneBtn: UIButton!
    @IBOutlet weak var addContactBtn: UIButton!
    
    
    var contactPersonToDisplay: [ContactPerson]! = []
    var user : User!
    var errorInContactsValidation : Bool = false
    var errorInPersonalPhoneValidation : Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.isEnabled = false
        approvePhoneBtn.isEnabled = false
        getUserInfo()
        getContactInfo()
        //self.tableView.reloadData()
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
    
    @IBAction func pressEditPhoneBtn(_ sender: Any) {
        phoneNumField.isEnabled = true
        approvePhoneBtn.isEnabled = true
    }
    
    @IBAction func pressApprovePhoneBtn(_ sender: Any) {
        //need to add verification for phone num
        textFieldsValidations(phoneNumField)
        if (errorInPersonalPhoneValidation){
            errorInPersonalPhoneValidation = false
            phoneNumField.text = user.myPhoneNum
            DispatchQueue.main.async {
                self.phoneNumField.isEnabled = false
                self.approvePhoneBtn.isEnabled = false
                self.submitBtn.isEnabled = true
                self.submitBtn.isEnabled = false
                self.showAlertMessage()
            }
            //errorInPersonalPhoneValidation = false
            return
        }
        
        user.setMyPhoneNumber(myPhoneNum: phoneNumField.text!)
        DispatchQueue.main.async {self.phoneNumField.isEnabled = false}
        DispatchQueue.main.async {self.approvePhoneBtn.isEnabled = false}
        DispatchQueue.main.async {self.submitBtn.isEnabled = true}
    }
    
    
    @IBAction func pressAddContactBtn(_ sender: Any) {
        //Verification for fields data
        textFieldsValidations(contactFirstNameField)
        textFieldsValidations(contactLastNameField)
        textFieldsValidations(contactPhoneField)
        if (errorInContactsValidation){
            showAlertMessage()
            errorInContactsValidation = false
            self.submitBtn.isEnabled = false
            return
        }
        
        contactPersonToDisplay.append(ContactPerson(firstName: contactFirstNameField.text!, lastName: contactLastNameField.text!, phoneNum: contactPhoneField.text!))
        DispatchQueue.main.async { self.tableView.reloadData() }
        DispatchQueue.main.async {self.submitBtn.isEnabled = true}
        
    }
    
    @IBAction func pressSubmitBtn(_ sender: Any) {
        
        //update the app user object to contain the array of contact that appears in the UI
        user.emergncyContacts = contactPersonToDisplay
        
        //make submit button disabled again
        DispatchQueue.main.async {self.submitBtn.isEnabled = false}
        
        //perform call to the server with the new details to update - TBD
        updateUserInfo(sender)
        //DispatchQueue.main.async {self.performSegue(withIdentifier: "submitSegue", sender: sender)}
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if(segue.identifier == "signUpSegue"){
//            getUserInfo()
//        }
//    }
 
    func getUserInfo(){
        let userId = UserDefaults.standard.string(forKey: "userID")
        let params = ["userid": userId] as! Dictionary<String, String>
        var components = URLComponents(string: "http://10.0.0.34:8080/getUserSettingInfo")!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)
        //var request = URLRequest(url: URL(string: "")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let response = response as! HTTPURLResponse
                if (response.statusCode != 200){
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    self.showGetInfoAlertMessage(message: json["message"]! as! String)
                    print(response.statusCode)
                }
                else{
                    print(data!)
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    self.saveUserInfo(json : json, userId: userId!)
                    self.displayUserInfo()
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }

    func getContactInfo(){
        let userId = UserDefaults.standard.string(forKey: "userID")
        let params = ["userid": userId] as! Dictionary<String, String>
        var components = URLComponents(string: "http://10.0.0.34:8080/getContactsInfo")!
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)
        //var request = URLRequest(url: URL(string: "")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let response = response as! HTTPURLResponse
                if (response.statusCode != 200){
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    self.showGetInfoAlertMessage(message: json["message"]! as! String)
                    print(response.statusCode)
                } else {
                    print(data!)
                    let jsonDecoder = JSONDecoder()
                    let decoded = try! jsonDecoder.decode([ContactPerson2].self, from: data!)
                    if (decoded.count == 0 ) {
                        print("No Contact Available")
                    } else {
                        print(decoded[0].firstName)
                        self.saveContactsInfo(decodedData : decoded, userId: userId!)
                    }
                }
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func saveUserInfo(json : Dictionary<String, AnyObject>, userId: String ) {
        
        user = User(userID: userId, firstName: json["fname"]! as! String, lastName: json["lname"]! as! String, email: "", pw: "", myPhoneNum: json["phoneNumber"]! as! String)
    }
    
    func saveContactsInfo(decodedData : [ContactPerson2], userId: String ) {
        for item in decodedData {
            print(item.firstName)
            print(item.lastName)
            print(item.phoneNum)
            user.addContactPerson(contactFirstName: item.firstName, contactLastName: item.lastName, contactPhoneNum: item.phoneNum)
        }
        contactPersonToDisplay = user.getContactPerson()!
        //self.tableView.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
    func displayUserInfo(){
        DispatchQueue.main.async{
            self.fNaneField.text = self.user.firstName
            self.lNameField.text = self.user.lastName
            self.phoneNumField.text = self.user.myPhoneNum
            self.phoneNumField.isEnabled = false
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (contactPersonToDisplay != nil) {
            print(contactPersonToDisplay.count)
            return contactPersonToDisplay.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellContactPerson", for: indexPath)
        let contact = contactPersonToDisplay[indexPath.row]
        cell.textLabel?.text = contact.firstName + "    " + contact.lastName + "    " + contact.phoneNum
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.contactPersonToDisplay.remove(at: indexPath.row)
            //update the app user object to contain the array of contact that appears in the UI
            user.emergncyContacts = contactPersonToDisplay
            tableView.deleteRows(at: [indexPath], with: .fade)
            submitBtn.isEnabled = true
        }
    }
    
    func updateUserInfo(_ sender: Any){
        //perform api call with all the user object data
        let userId = UserDefaults.standard.string(forKey: "userID") ?? "0"
        var prepareContactsToEncode = [ContactPerson2]()
        for contact in user.emergncyContacts{
            prepareContactsToEncode.append(ContactPerson2(firstName: contact.firstName, lastName: contact.lastName, phoneNum: contact.phoneNum))
        }

        let encodableParams = submitInfo(userid: userId, FirstName: user.firstName, LastName: user.lastName, phoneNumber: user.myPhoneNum, contactPersons: prepareContactsToEncode)
        let jsonEncoder = JSONEncoder()
        let paramsData = try! jsonEncoder.encode(encodableParams)
        //let params = String(data: paramsData, encoding: .utf8)!
        //print(params)
        
        var request = URLRequest(url: URL(string: "http://10.0.0.34:8080/submitSetting")!)
        request.httpMethod = "POST"
        request.httpBody = paramsData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
//                print(json)
//                print(json["FaultId"]!)
//                for (key, value) in json {
//                    print("\(key) -> \(value)")
//                }
                if (json["actionSucceed"] as! Bool){
                    DispatchQueue.main.async {self.performSegue(withIdentifier: "submitSegue", sender: sender)}
                } else {
                    print(json["errorMsg"]!)
                    self.showGetInfoAlertMessage(message: json["errorMsg"]! as! String)
                    return
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    //validations and error handaling for all the  login text fields
    func textFieldsValidations(_ textField: UITextField){
        switch (textField.tag) {
        case settingsView.phoneNumTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.phoneNo, phoneNumField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
                self.errorInPersonalPhoneValidation = true
            }
            break;
        case settingsView.contactFirstNameTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, contactFirstNameField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
                self.errorInContactsValidation = true
            }
            break;
        case settingsView.contactLastNameTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.stringWithFirstLetterCaps, contactLastNameField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
                self.errorInContactsValidation = true
            }
            break;
        case settingsView.contactPhoneTag.rawValue:
            let response = Validation.shared.validate(values: (ValidationType.phoneNo, contactPhoneField.text!))
            switch response {
            case .success:
                break
            case .failure(_, let message):
                print(message.localized())
                self.errorInContactsValidation = true
            }
            break;
        default:
            break;
        }
    }
    
    func showAlertMessage() {
        DispatchQueue.main.async {
            let message = "One or more text fields values are invalid. \n Please verify names appears with capitals and phone numbers are valid"
            let alertMessage = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertMessage.addAction(cancelAction)
            
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    func showGetInfoAlertMessage(message:String){
        let alertMessage = UIAlertController(title: "Something Went Wrong", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertMessage.addAction(cancelAction)
        
        self.present(alertMessage, animated: true, completion: nil)
    }
}
