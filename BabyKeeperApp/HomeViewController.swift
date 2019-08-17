//
//  HomeViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 10/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var settingsBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var startSimulationBtn: UIButton!
    @IBOutlet weak var alarmLable: UILabel!
    @IBOutlet weak var falseAlarmBtn: UIButton!
    @IBOutlet weak var handledAlarmBtn: UIButton!
    
    var user: User = User(userID: "", firstName: "", lastName: "", email: "", pw: "", myPhoneNum: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didPressLogoutBtn(_ sender: Any) {
        showLogoutAreYouSureMessage(sender)
    }
    
    @IBAction func didPressStartSimulationBtn(_ sender: Any) {
        //TBD send trigger for the backend to check picture
        
        //in case of baby recognition
        alarmLable.isHidden = false
        falseAlarmBtn.isHidden = false
        falseAlarmBtn.isEnabled = true
        handledAlarmBtn.isHidden = false
        handledAlarmBtn.isEnabled = true
        
    }
    
    @IBAction func didPressFalseAlarmBtn(_ sender: Any) {
        
        //send triger to the backend
        
        alarmLable.isHidden = true
        falseAlarmBtn.isHidden = true
        falseAlarmBtn.isEnabled = false
        handledAlarmBtn.isHidden = true
        handledAlarmBtn.isEnabled = false
    }
    
    @IBAction func didPressHandeledAlarmBtn(_ sender: Any) {
        
        //send triger to the backend
        
        alarmLable.isHidden = true
        falseAlarmBtn.isHidden = true
        falseAlarmBtn.isEnabled = false
        handledAlarmBtn.isHidden = true
        handledAlarmBtn.isEnabled = false
    }
    
    func displayUserName(){
        let nameToDisplay = user.getFirstName() + " " + user.getLastName()
        print(nameToDisplay)
        nameLabel.text = nameToDisplay
    }
    
    func getUserInfo(){
        let userId = UserDefaults.standard.string(forKey: "userID")
        let params = ["userid": userId] as! Dictionary<String, String>
        var components = URLComponents(string: "http://localhost:8080/getUserSettingInfo")!
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
                    //self.showGetInfoAlertMessage(message: json["message"]! as! String)
                    print(response.statusCode)
                }
                else{
                    print(data!)
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    self.user.setUserID(userID: userId!)
                    self.user.setFirstName(firstName: json["fname"] as! String)
                    self.user.setLastName(lastName: json["lname"] as! String)
                    DispatchQueue.main.async {self.displayUserName()}
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
    }
    
    func showLogoutAreYouSureMessage(_ sender: Any) {
        DispatchQueue.main.async {
            let message = "Do you wish to sign out?"
            let dialogMessage = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let signout = UIAlertAction(title: "Sign Out", style: .default, handler: { (action) -> Void in
                print("Sign Out")
                self.PerformSignOut(sender)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                print("Cancel button tapped")
            }
            dialogMessage.addAction(signout)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
    }
    
    func PerformSignOut(_ sender: Any){
        UserDefaults.standard.removeObject(forKey: "userID")
        self.performSegue(withIdentifier: "signOutSegue", sender: sender)
    }
    
    func doBlinkAlarm(){
        
    }
}
