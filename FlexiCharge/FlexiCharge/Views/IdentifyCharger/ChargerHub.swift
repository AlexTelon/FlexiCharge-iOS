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
    var chargers: [ChargerTest]
    var distance: String
}

struct ChargerTest: Decodable, Identifiable {
    var chargerID: Int
    var location: [CGFloat]
    var chargePointID: Int
    var serialNumber: String
    var status: Int
    
    var id: Int {
        chargerID
    }
}
