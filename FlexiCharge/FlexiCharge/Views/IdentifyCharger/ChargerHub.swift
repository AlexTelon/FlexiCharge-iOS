//
//  Charger.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import Foundation
import Combine
import SwiftUI

struct ChargerHub: Decodable, Identifiable, Equatable {
    var chargePointID: Int
    var name: String
    var location: [CGFloat]
    var price: String
    var klarnaReservationAmount: Int
    
    var id: Int {
        chargePointID
    }
}

struct Charger: Decodable, Identifiable, Equatable {
    var chargerID: Int
    var location: [CGFloat]
    var chargePointID: Int
    var serialNumber: String
    var status: String
    
    var id: Int {
        chargerID
    }
}

struct ChargerHubExt: Decodable, Identifiable, Equatable {
    var chargePointID: Int
    var name: String
    var location: [CGFloat]
    var price: String
    var klarnaReservationAmount: Int
    var chargers: [Charger]
    
    var id: Int {
        chargePointID
    }
}
