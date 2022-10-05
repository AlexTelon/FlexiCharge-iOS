//
//  RegisterAccountViewModel.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-13.
//

import Foundation


func validateEmail(email: String)->String{
    var errorMessage: String = ""
    if email.count < 100 {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !(emailPredicate.evaluate(with: email)){
            errorMessage = "Invalid email adress format"
        }
    }else{
        errorMessage = "Invalid email adress format"
    }
    return errorMessage
}

func validatePassword(password: String)->String{
    var errorMessages: String = ""
    var validPassword: Bool = false
    
    let specialCharacters = CharacterSet.punctuationCharacters
    let upperCaseCharacters = CharacterSet.uppercaseLetters
    let lowerCaseCharacters = CharacterSet.lowercaseLetters
    let numbers = CharacterSet.decimalDigits
    
    let hasSpecialCharacter = password.description.rangeOfCharacter(from: specialCharacters)
    let hasUppercaseCharacter = password.description.rangeOfCharacter(from: upperCaseCharacters)
    let hasLowerCasecharacters = password.description.rangeOfCharacter(from: lowerCaseCharacters)
    let hasNumber = password.description.rangeOfCharacter(from: numbers)
    
    
    //Checks for special characters, uppercase characters and lowercase characters
    validPassword = hasSpecialCharacter != nil ? true : false
    if validPassword{
        
        validPassword = hasUppercaseCharacter != nil ? true : false
        if validPassword{
            
            validPassword = hasLowerCasecharacters != nil ? true : false
            if validPassword{
                validPassword = hasNumber != nil ? true : false
                if !validPassword{
                    errorMessages = "Password must contain a number"
                }
            }else{
                errorMessages = "Password must contain lowercase characters"
            }
            
        }else{
            errorMessages = "Password must contain uppercase character"
        }
        
    }else{
        errorMessages = "Password must contain atleast 1 special character"
    }
    
    //Checks if password is atleast 8 characters
    if password.count <= 8 /*|| repeavalidPasswordtedPassword.count < 7*/ {
        errorMessages = "Password must be atleast 8 characters"
    }
    return errorMessages
}
    


func validateInputs(email: String, password: String, /*repeatedPassword: String,*/ TOSCheckBox: Bool) ->String{
    var errorMessage:String = ""
    if email.count < 100 {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if !(emailPredicate.evaluate(with: email)){
            errorMessage += "Invalid email address";
            return errorMessage
        }
    }
    if password.count < 8 /*|| repeatedPassword.count < 7*/ {
        errorMessage += "Password needs to be at least 7 characters"
        return errorMessage
    }
    if !TOSCheckBox {
        errorMessage += "Please agree to the terms and conditions"
        return errorMessage
    }
    //errorMessage += ""
    return errorMessage
}
