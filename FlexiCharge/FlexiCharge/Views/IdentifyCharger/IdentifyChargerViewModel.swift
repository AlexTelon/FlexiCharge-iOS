//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation

func getChargerStatus(chargers: ChargerAPI, chargerId: Int) -> String {
    if let charger = chargers.result.first(where: {$0.chargerID == chargerId}) {
        return charger.status
    }
    return "nil"
}
