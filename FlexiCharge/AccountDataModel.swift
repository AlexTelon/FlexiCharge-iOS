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
        let def = UserDefaults.standard
        def.set(true, forKey: "isLoggedIn") // save true flag to UserDefaults
        def.synchronize()
     }
    
    func setLoggedInToFalse() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    
}
