//
//  AlertMessages.swift
//  BabyKeeperApp
//
//  Created by Nofar Kedem Zada on 27/07/2019.
//  Copyright © 2019 Nofar Kedem Zada. All rights reserved.
//

import Foundation

enum AlertMessages: String {
    case inValidEmail = "Invalid Email"
    case invalidFirstLetterCaps = "First Letter should be capital"
    case inValidPhone = "Invalid Phone"
    case invalidAlphabeticString = "Invalid String"
    case inValidPSW = "Invalid Password"
    
    case emptyPhone = "Empty Phone"
    case emptyEmail = "Empty Email"
    case emptyFirstLetterCaps = "Empty Name"
    case emptyAlphabeticString = "Empty String"
    case emptyPSW = "Empty Password"
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
