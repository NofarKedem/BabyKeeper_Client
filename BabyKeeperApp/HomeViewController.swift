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
    @IBOutlet weak var startSimulation1: UIButton!
    @IBOutlet weak var startSimulation2: UIButton!
    @IBOutlet weak var alarmLable: UILabel!
    @IBOutlet weak var falseAlarmBtn: UIButton!
    @IBOutlet weak var handledAlarmBtn: UIButton!
    @IBOutlet weak var alartImage: UIImageView!
    
    var user: User = User(userID: "", firstName: "", lastName: "", email: "", pw: "", myPhoneNum: "")
    var imageUrlToDisplay : String = ""
    var isThereChildrenInTheCar : Bool = false
    
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
        sendTriggerToServer(simulationID: "0")
    }
    
    @IBAction func didPressStartSimulation1Btn(_ sender: Any) {
        sendTriggerToServer(simulationID: "1")
    }
    
    
    @IBAction func didPressStartSimulation2(_ sender: Any) {
        sendTriggerToServer(simulationID: "2")
    }
    
    @IBAction func didPressFalseAlarmBtn(_ sender: Any) {
        
        //send triger to the backend
        
        alarmLable.isHidden = true
        falseAlarmBtn.isHidden = true
        falseAlarmBtn.isEnabled = false
        handledAlarmBtn.isHidden = true
        handledAlarmBtn.isEnabled = false
        alartImage.isHidden = true
        self.isThereChildrenInTheCar = false
    }
    
    @IBAction func didPressHandeledAlarmBtn(_ sender: Any) {
        
        //send triger to the backend
        
        alarmLable.isHidden = true
        falseAlarmBtn.isHidden = true
        falseAlarmBtn.isEnabled = false
        handledAlarmBtn.isHidden = true
        handledAlarmBtn.isEnabled = false
        alartImage.isHidden = true
        self.isThereChildrenInTheCar = false
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
    
    func sendTriggerToServer(simulationID : String){
        let params = ["simulationID": simulationID]
        print(params)
        var components = URLComponents(string: "http://localhost:8080/startSimulation")!
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
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    self.imageUrlToDisplay = json["picUrl"] as! String
                    self.isThereChildrenInTheCar = json["thereChildrenInTheCar"] as! Bool
                    DispatchQueue.main.async {self.displayAlarm()}
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
        
    }

    
    func displayAlarm() {
        if(self.isThereChildrenInTheCar){
            alarmLable.isHidden = false
            falseAlarmBtn.isHidden = false
            falseAlarmBtn.isEnabled = true
            handledAlarmBtn.isHidden = false
            handledAlarmBtn.isEnabled = true
            
            //get image to display
            let url = URL(string: imageUrlToDisplay)!
            
            self.getImage(for: url, completion: { (image) in
                self.alartImage.image = image
            })
            alartImage.isHidden = false
        }
        else {
            return
        }
    }
    
    
    //image handaling
    
    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        performRequest(url: url) { data in
            DispatchQueue.main.async {
                completion(UIImage.image(from: data))
            }
        }
    }
    
    func performRequest(url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error)
            }
            
            completion(data)
            }.resume()
    }
}

extension UIImage {
    static func image(from data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        
        return UIImage(data: data)
    }
}
