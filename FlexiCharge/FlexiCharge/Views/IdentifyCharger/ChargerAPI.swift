//
//  ChargerAPI.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-22.
//

import Foundation
import Combine
import SwiftUI

class ChargerAPI: ObservableObject {
    var chargerStatus: String = ""
    let baseUrl: String = "http://18.202.253.30:8080"
    
    @Published var chargers = [Charger]()
    @Published var chargePoints = [ChargerHub]()
    @Published var chargePointsExt = [ChargerHubExt]()
    
    init() {
        
    }
    
    func beginCharging(chargerID: Int, completion: @escaping (String) -> Void) -> Void {
        guard let url = URL(string: "\(baseUrl)/reservations/" + String(chargerID)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: String] = [
            "chargerId": String(chargerID),
            "connectorId": "1",
            "idTag": "1",
            "reservationId": "1",
            "parentIdTag": "1"
        ]
        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if error != nil {
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 201 else {
                    let responseCodeAsString = String(responseCode)
                    completion(responseCodeAsString)
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    let responseDataAsString = responseJSONData as! String
                    completion(responseDataAsString)
                }
            }
        }.resume()
        return
    }
    
    func stopCharging(chargerID: Int) {
        guard let url = URL(string: "\(baseUrl)/chargers/" + String(chargerID)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: String] = [
            "status": StatusConstants.AVAILABLE,
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if error != nil {
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
    
    func loadChargePoints(completionHandler: @escaping() -> Void) {
        //Fetches all chargePoints
        guard let url = URL(string: "\(baseUrl)/chargePoints") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([ChargerHub].self, from: data)

            DispatchQueue.main.async {
                self.chargePoints = decodedData
                print("loadChargePoints")
                self.loadChargers{
                    completionHandler()
                }
            }
        }.resume()
    }

    func loadChargers(completionHandler: @escaping() -> Void) {
        // Fetches all chargers
        guard let url = URL(string: "\(baseUrl)/chargers") else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            let decodedData = try! JSONDecoder().decode([Charger].self, from: data)

            DispatchQueue.main.async {
                self.chargers = decodedData
                print("loadChargers")
                completionHandler()
            }
        }.resume()
    }

    func updateChargers() {
        // Fetches chargers to update the map if a change has occured
        guard let url = URL(string: "\(baseUrl)/chargers") else { return }
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                guard let data = data else { return }
                let decodedData = try! JSONDecoder().decode([Charger].self, from: data)

                DispatchQueue.main.async {
                    if self.chargers != decodedData {
                        self.chargers = decodedData
                    }
                    self.updateChargers()
                }
            }.resume()
        }
    }
}

