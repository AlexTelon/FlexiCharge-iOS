//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation

func getChargerStatus(chargers: [Charger], chargerId: Int) -> String {
    guard let charger = chargers.first(where: {$0.chargerID == chargerId}) else { return "No charger found"}
    return charger.status
}
