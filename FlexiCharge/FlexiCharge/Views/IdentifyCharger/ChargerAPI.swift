//
//  ChargerAPI.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-22.
//

import Foundation
import Combine
import SwiftUI

struct ChargerTest: Decodable {
    var chargerID: Int
    var location: [CGFloat]
    var chargePointID: Int
    var serialNumber: String
    var status: Int
}

class ChargerAPI {
    var didChange = PassthroughSubject<ChargerAPI, Never>()
    var chargers = [ChargerTest](){
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        // Fetches all chargers
        guard let url = URL(string: "http://54.220.194.65:8080/chargers") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([ChargerTest].self, from: data)
            
            DispatchQueue.main.async {
                self.chargers = decodedData
            }
            print(decodedData)
        }.resume()
    }
}
