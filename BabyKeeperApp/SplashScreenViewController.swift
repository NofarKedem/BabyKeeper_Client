//
//  SplashScreenViewController.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 17/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        sleep(5)
        activityIndicator.stopAnimating()
        tryAutoLogin()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tryAutoLogin(){
        if((UserDefaults.standard.string(forKey: "userID")) == nil){ //I have a user id in the session - go to home page
            performSegue(withIdentifier: "splashScreenSegue", sender: self)
            
        }else{ //I dont have user id in the session - go to login
            performSegue(withIdentifier: "autoLoginSegue", sender: self)
        }
    }
}
