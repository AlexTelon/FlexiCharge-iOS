//
//  VerifyAccountViewModel.swift
//  FlexiCharge
//
//  Created by david Wennerblom on 2022-09-20.
//

import Foundation




func validateInputs(username: String, validationCode: String) ->String{
    var errorMessage:String = ""
//    if email.count < 100 {
//        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//
//        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
//        if !(emailPredicate.evaluate(with: email)){
//            errorMessage += "Invalid email address";
//            return errorMessage
//        }
//    }
    if(username.contains(" ")){
        errorMessage = "username contains whitespaces"
        return errorMessage
    }
    if(username == ""){
        return "Please provide a username"
        
    }
    
    if(validationCode == ""){
        return "Please provide the verification code"
    }
    return errorMessage
}
