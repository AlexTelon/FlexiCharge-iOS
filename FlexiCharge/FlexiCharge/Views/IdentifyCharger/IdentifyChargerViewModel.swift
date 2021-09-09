//
//  IdentifyChargerViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-09.
//

import Foundation
let testChargers: [Int: Int] = [111111:1, 123456:2, 133777:3]

func getChargerStatus(chargerId: Int) -> Int{
    let notIdentified: Int = 0
    let success: Int = 1
    let occupied: Int = 2
    let outOfOrder: Int = 3

    if (testChargers[chargerId] == 1) {
        return success
    } else if testChargers[chargerId] == 2 {
        return occupied
    } else if testChargers[chargerId] == 3 {
        return outOfOrder
    }else{
        return notIdentified
    }
}
