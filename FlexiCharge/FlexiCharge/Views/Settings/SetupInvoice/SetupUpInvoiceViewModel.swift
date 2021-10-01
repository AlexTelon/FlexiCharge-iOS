//
//  SetupUpInvoiceViewController.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-20.
//

import Foundation

func validateSetupInvoice (name: String, address: String, postcode: String, town: String) ->String {
    var validationMessage: String = ""
    let decimalCharacters = CharacterSet.decimalDigits
    let decimalRange = name.rangeOfCharacter(from: decimalCharacters)
    
    if name.isEmpty {
        validationMessage += "Enter a name"
        return validationMessage
    }
    if decimalRange != nil {
        validationMessage += "Enter a valid name"
        return validationMessage
    }
    if address.isEmpty {
        validationMessage += "Enter an address"
        return validationMessage
    }
    if postcode.isEmpty {
        validationMessage += "Enter a postcode"
        return validationMessage
    }
    if town.isEmpty {
        validationMessage += "Enter a town"
        return validationMessage
    }
    return ""
}
