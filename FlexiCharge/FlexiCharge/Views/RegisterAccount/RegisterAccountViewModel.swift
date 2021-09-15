//
//  RegisterAccountViewModel.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-13.
//

import Foundation



func validateInputs(email: String, mobileNumber: String, password: String, /*repeatedPassword: String,*/ TOSCheckBox: Bool) ->String{
    var errorMessage:String = ""
    if email.count < 100 {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !(emailPredicate.evaluate(with: email)){
            errorMessage += "Invalid email address";
            return errorMessage
        }
    }
    if mobileNumber.count > 10 || mobileNumber.count < 10 || mobileNumber.isEmpty {
        errorMessage += "Invalid phone number"
        return errorMessage
    }
    if password.count < 7 /*|| repeatedPassword.count < 7*/ {
        errorMessage += "Password needs to be at least 7 characters"
        return errorMessage
    }
    if !TOSCheckBox {
        errorMessage += "Please agree to the terms and conditions"
        return errorMessage
    }
    errorMessage += ""
    return errorMessage
}
