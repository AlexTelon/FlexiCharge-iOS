//
//  AccountDataModel.swift
//  FlexiCharge
//
//  Created by david Wennerblom on 2022-09-16.
        //

import Foundation
import Combine
import SwiftUI



class AccountDataModel: ObservableObject {
    
    var accessToken: String
    var email: String
    var username: String
    var firstName: String
    var lastName: String
    var userId: String
    
    init(){
        accessToken = ""
        email = ""
        username = ""
        firstName = ""
        lastName = ""
        userId = ""
    }
    
    func saveLoggedState() {
        UserDefaults.standard.set(true, forKey: "isLoggedIn") // save true flag to UserDefaults
        UserDefaults.standard.synchronize()
     }
    
    func setLoggedInToFalse() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func getLoggedInStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    
}
