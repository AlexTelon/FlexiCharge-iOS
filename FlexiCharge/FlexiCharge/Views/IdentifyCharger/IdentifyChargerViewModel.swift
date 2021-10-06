//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation

func getChargerStatus(chargers: [Charger], chargerId: Int) -> String {
    if let charger = chargers.first(where: {$0.chargerID == chargerId}) {
        return charger.status
    }
    return "nil"
}
