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
    
    private var accessToken: String
    private var email: String
    private var username: String
    private var firstName: String
    private var lastName: String
    private var userId: String
    
    init(){
        accessToken = ""
        email = ""
        username = ""
        firstName = ""
        lastName = ""
        userId = ""
    }
    
    
}
