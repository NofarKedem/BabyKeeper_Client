//
//  HomeViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 10/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
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
    
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func didPressLogoutBtn(_ sender: Any) {
        showLogoutAreYouSureMessage(sender)
    }
    
    @IBAction func didPressStartSimulationBtn(_ sender: Any) {
        //sendTriggerToServer(simulationID: "0")
        importPicture()
        //uploadImageToServer()
        
    }

    
//    @IBAction func didPressFalseAlarmBtn(_ sender: Any) {
//
//        //send triger to the backend
//
//        alarmLable.isHidden = true
//        falseAlarmBtn.isHidden = true
//        falseAlarmBtn.isEnabled = false
//        handledAlarmBtn.isHidden = true
//        handledAlarmBtn.isEnabled = false
//        alartImage.isHidden = true
//        self.isThereChildrenInTheCar = false
//    }
    
    @IBAction func didPressHandeledAlarmBtn(_ sender: Any) {
        
        //send triger to the backend
        
        alarmLable.isHidden = true
        //falseAlarmBtn.isHidden = true
        //falseAlarmBtn.isEnabled = false
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
                if error != nil{
                    //handel error
                    print(error!.localizedDescription)
                    self.showAlertMessage(message: "No Internet Connection. Some actions might not work as expected")
                    return
                }
                let response = response as! HTTPURLResponse
                if (response.statusCode != 200){
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    self.showAlertMessage(message: "Something went wrong...\n Please try again later")
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
    
    func displayAlarm() {
        if(self.isThereChildrenInTheCar){
            alarmLable.text = "Attention! Baby is IN the Car!!!"
            alarmLable.textColor = UIColor.red
            
            alarmLable.isHidden = false
            //falseAlarmBtn.isHidden = false
            //falseAlarmBtn.isEnabled = true
            handledAlarmBtn.isHidden = false
            handledAlarmBtn.isEnabled = true
            alartImage.isHidden = false
            alartImage.image = currentImage
            //get image to display when using storage
//            let url = URL(string: imageUrlToDisplay)!
//
//            self.getImage(for: url, completion: { (image) in
//                self.alartImage.image = image
//            })
            
            //display image
            
            
        }
        else{
            alarmLable.text = "You are all Safe!"
            alarmLable.textColor = UIColor.white
            alarmLable.isHidden = false
            //falseAlarmBtn.isHidden = false
            //falseAlarmBtn.isEnabled = true
            handledAlarmBtn.isHidden = false
            handledAlarmBtn.isEnabled = true
            alartImage.isHidden = false
            alartImage.image = currentImage
        }
        
    }
    
    
    func showAlertMessage(message:String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertMessage.addAction(cancelAction)
            
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    //test import image
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        //alartImage.image = currentImage
        uploadImageToServer()
        
    }
    
    
    func uploadImageToServer(){
        let userID = UserDefaults.standard.string(forKey: "userID") ?? "0"
        let imgData = currentImage.pngData()?.base64EncodedString()
        let params = ["userId" : userID,
                    "img": imgData] as! Dictionary<String, String>
        var request = URLRequest(url: URL(string: "http://localhost:8080/uploadImg")!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                //print(response!)
                if error != nil{
                    //handel error
                    print(error!.localizedDescription)
                    self.showAlertMessage(message: "Please check your network connection and try again")
                    return
                }
                
                let response = try response as! HTTPURLResponse
                if response.statusCode != 200 {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    //print(json["errorMsg"]!)
                    self.showAlertMessage(message: "Something went wrong...\n Please try again later")
                    
                }
                else{
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    print(json)
                    self.isThereChildrenInTheCar = json["thereChildrenInTheCar"] as! Bool
                    DispatchQueue.main.async {self.displayAlarm()}
    
                }
                
            } catch {
                print("error")
            }
        })
        
        task.resume()
        
    }
    
    //image handaling - when pulling image from storage
    
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
                if error != nil{
                    //handel error
                    print(error!.localizedDescription)
                    self.showAlertMessage(message: "The connection to the server failed")
                    return
                }
                
                let response = response as! HTTPURLResponse
                if (response.statusCode != 200){
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    self.showAlertMessage(message: "Something went wrong...\n Please try again later")
                    print(response.statusCode)
                    print(json["errorMsg"]!)
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
