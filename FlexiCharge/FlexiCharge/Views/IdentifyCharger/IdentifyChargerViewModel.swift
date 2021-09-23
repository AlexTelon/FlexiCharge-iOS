//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation

func getChargerStatus(chargers: ChargerAPI, chargerId: Int) -> Int {
    let notIdentified: Int = 5
    if let charger = chargers.result.first(where: {$0.chargerID == chargerId}) {
        return charger.status
    }
    return notIdentified
}
