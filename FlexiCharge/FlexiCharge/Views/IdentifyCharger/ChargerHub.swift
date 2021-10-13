//
//  Charger.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import Foundation
import Combine
import SwiftUI

struct ChargerHub: Identifiable {
    var id: Int
    var chargerLocationName: String
    var chargers: [Charger]
    var distance: String
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
