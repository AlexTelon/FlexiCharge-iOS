//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation
let testChargers: [Int: Int] = [111111: 1, 123456: 2, 133777: 3]


func getChargerStatus(chargerId: Int) -> Int {
    let notIdentified: Int = 0
    if testChargers[chargerId] == nil {
            return notIdentified
    }
    return testChargers[chargerId]!
}
