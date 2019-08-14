//
//  SettingsInfo.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 12/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation

struct SettingInfo : Decodable{
    let contactList : [ContactPerson2]
    
}

struct ContactPerson2 : Codable {
    let firstName : String
    let lastName : String
    let phoneNum : String
}

struct submitInfo : Codable {
    let userid : String
    let FirstName : String
    let LastName : String
    let phoneNumber : String
    let contactPersons : [ContactPerson2]
}

