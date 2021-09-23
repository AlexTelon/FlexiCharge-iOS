//
//  InvoicesViewModel.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-21.
//

import Foundation
struct invoice {
    var invoiceID: Int = 0
    var name: String = ""
    var address: String = ""
    var postcode: String = ""
    var town: String = ""
    var monthYear: String = ""
    var cost: Double = 0
}

struct invoicedSession {
    var sessionID: Int = 0
    var location: String = ""
    var sessionCost: Double = 0
}

//For testing, will be changed when we have a backend :endme:

let chargingSession = invoicedSession(sessionID: 1, location: "There will be data here", sessionCost: 25)
let chargingSession1 = invoicedSession(sessionID: 2, location: "Högskolan", sessionCost: 13.37)
let chargingSession2 = invoicedSession(sessionID: 3, location: "Resecentrum", sessionCost: 42.69)

var lucasJune = invoice(invoiceID: 1, name: "Lucas Strand", address: "Vevslupsgränd 3", postcode: "55330", town: "Jönköping", monthYear: "June 2021", cost: chargingSession.sessionCost + chargingSession1.sessionCost + chargingSession2.sessionCost)
let lucasJuly = invoice(invoiceID: 2, name: "Lucas Strand", address: "Vevslupsgränd 3", postcode: "55330", town: "Jönköping", monthYear: "July 2021" , cost: 104.34)
let lucasAugust = invoice(invoiceID: 3, name: "Lucas Strand", address: "Vevslupsgränd 3", postcode: "55330", town: "Jönköping", monthYear: "August 2021" , cost: 104.34)

func getInvoice() -> invoice {
    return lucasJune
}
func getInvoiceInfo() -> invoicedSession {
    return chargingSession
}
