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
    @Published var isLoggedIn: Bool
    
    init(){
        accessToken = ""
        email = ""
        username = ""
        firstName = ""
        lastName = ""
        userId = ""
        isLoggedIn = false
    }
    
    
}
