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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.isEnabled = false
        approvePhoneBtn.isEnabled = false
        getUserInfo()
        
    }
    
    @IBAction func pressEditPhoneBtn(_ sender: Any) {
        phoneNumField.isEnabled = true
        approvePhoneBtn.isEnabled = true
    }
    
    @IBAction func pressApprovePhoneBtn(_ sender: Any) {
        //need to add verification for phone num
        user.setMyPhoneNumber(myPhoneNum: phoneNumField.text!)
        DispatchQueue.main.async {self.phoneNumField.isEnabled = false}
        DispatchQueue.main.async {self.approvePhoneBtn.isEnabled = false}
    }
    
    
    @IBAction func pressAddContactBtn(_ sender: Any) {
        //need to add verification for fields data
        
        //user.addContactPerson(contactFirstName: contactFirstNameField.text!, contactLastName: contactLastNameField.text!, contactPhoneNum: contactPhoneField.text!)
        contactPersonToDisplay.append(ContactPerson(firstName: contactFirstNameField.text!, lastName: contactLastNameField.text!, phoneNum: contactPhoneField.text!))
        DispatchQueue.main.async { self.tableView.reloadData() }

        
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
        //user id should be change to get from session ?
        let userId = "123"
        let params = ["userid": userId] as Dictionary<String, String>
        var components = URLComponents(string: "http://localhost:8080/getSettingsInfo")!
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
                    //handle error
                    print(response.statusCode)
                }
                else{
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //print(json)
                    self.saveUserInfo(json : json)
                    //print(self.user.getMyPhoneNumber())
                    self.displayUserInfo()
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func saveUserInfo(json : Dictionary<String, AnyObject> ) {
        user = User(userID: json["UserID"]! as! String, firstName: json["Fname"]! as! String, lastName: json["Lname"]! as! String, email: json["email"]! as! String, pw: "", myPhoneNum: json["Mobile"]! as! String)
        user.addContactPerson(contactFirstName: json["EmergencyFName"]! as! String, contactLastName: json["EmergencyLName"]! as! String, contactPhoneNum: json["EmergencyMobile"]! as! String)
        contactPersonToDisplay = user.getContactPerson()!
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
        //return contactPersonToDisplay.count
        
//        if (user?.emergncyContacts != nil) {
//            return user.emergncyContacts.count
        if (contactPersonToDisplay != nil) {
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
    
}
