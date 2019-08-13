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

struct ContactPerson2 : Decodable {
    let firstName : String
    let lastName : String
    let phoneNum : String
}



