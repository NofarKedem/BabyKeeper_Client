//
//  User.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 24/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation

class User {
    var firstName : String
    var lastName : String
    var email : String
    var pw : String
    var myPhoneNum : String
    var emergncyContacts = [ContactPerson]()
    
    init(firstName : String, lastName : String, email : String, pw : String, myPhoneNum : String){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.pw = pw
        self.myPhoneNum = myPhoneNum
    }
    
    //setters
    func setFirstName(firstName : String){
        self.firstName = firstName
    }
    
    func setLastName(lastName : String){
        self.lastName = lastName
    }
    
    func setEmail(email : String){
        self.email = email
    }
    
    func setPW (pw : String){
        self.pw = pw
    }
    
    func setMyPhoneNumber(myPhoneNum : String){
        self.myPhoneNum = myPhoneNum
    }
    
    func addContactPerson(contactFirstName : String, contactLastName : String, contactPhoneNum : String){
        emergncyContacts.append(ContactPerson(firstName: contactFirstName, lastName: contactLastName, phoneNum: contactPhoneNum))
    }
    
    func removeContactPerson(){
        
    }
    
    //getters
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getPW() -> String {
        return self.pw
    }
    
    func getMyPhoneNumber() -> String {
        return self.myPhoneNum
    }
    
    //mostly for debbuing
    func printUserInfo(){
        print(self.firstName+"\n")
        print(self.lastName+"\n")
        print(self.email+"\n")
        print(self.pw+"\n")
        print(self.myPhoneNum+"\n")
    }
}
