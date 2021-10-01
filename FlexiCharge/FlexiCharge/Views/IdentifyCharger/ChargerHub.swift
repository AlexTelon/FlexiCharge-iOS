//
//  Charger.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import Foundation

struct ChargerHub: Identifiable {
    var id: Int
    var chargerLocationName: String
    var chargers: [Charger]
    var distance: String
}

struct Charger {
    var id: Int
    var type: Int
    var kW: Int
    var krPerkWh: Float
    var availability: String
}
