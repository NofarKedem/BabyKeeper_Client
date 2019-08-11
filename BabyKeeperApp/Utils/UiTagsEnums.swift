//
//  UiTagsEnums.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 27/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation


enum SignUpView : Int{
    case firstNameFieldTag = 0
    case lastNameFieldTag = 1
    case emailFieldTag = 2
    case pwFieldTag = 3
    case confirmPwTag = 4
    
    //return self.rawValue
    
};

enum LoginView : Int{
    case emailFieldTag = 0
    case pwFieldTag = 1

};

enum settingsView : Int{
    case phoneNumTag = 0
    case contactFirstNameTag = 1
    case contactLastNameTag = 2
    case contactPhoneTag = 3
    
};
