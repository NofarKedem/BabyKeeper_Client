//
//  ContactPerson.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 24/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation

class ContactPerson : Codable {
    var firstName : String
    var lastName : String
    var phoneNum : String
    
    
    init (firstName: String, lastName: String, phoneNum : String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNum = phoneNum
    }
    
    //setters
    func setFirstName(firstName : String){
        self.firstName = firstName
    }
    
    func setLastName(lastName : String){
        self.lastName = lastName
    }
    
    func setPhoneNumber(phoneNum : String){
        self.phoneNum = phoneNum
    }
    
    //getters
    func getFirstName() -> String {
        return self.firstName
    }
    
    func getLastName() -> String {
        return self.lastName
    }
    
    func getPhoneNumber() -> String {
        return self.phoneNum
    }
}
