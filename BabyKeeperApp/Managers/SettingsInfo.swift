//
//  SettingsInfo.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 12/08/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation

struct SettingInfo : Decodable{
    //let phoneNumber : String
    let contactList : [ContactPerson2]
    //let Fname : String
    //let Lname : String
}

struct ContactPerson2 : Decodable {
    let firstName : String
    let lastName : String
    let phoneNum : String
}



//{
//    "Fname" : "adi",
//    "Lname" : "adi",
//    "phoneNumber" : "98798798",
//    "contactList" : [ "firstName" : "sdi" ,
//                      "lastName" : "sd2sdsdi" ,
//                      "firstName" : "0983798763873"]
//}
