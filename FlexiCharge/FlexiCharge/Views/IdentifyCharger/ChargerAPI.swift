//
//  ChargerAPI.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-22.
//

import Foundation
import Combine
import SwiftUI

class ChargerAPI {
    
    var response: Any? = nil
    
    init() {
        
    }
    
    func beginCharging(chargerID: Int) -> Any {
        guard let url = URL(string: "http://54.220.194.65:8080/reservations/" + String(chargerID)) else { return "Not a valid URL" }
        
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
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
//                    self.response = responseCode
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
//                    self.response = responseJSONData
                }
            }
        }.resume()
        return "test"
    }
    
    func stopCharging(chargerID: Int) {
        guard let url = URL(string: "http://54.220.194.65:8080/chargers/" + String(chargerID)) else { return }
        
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
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 200 else {
                    print("Invalid response code: \(responseCode)")
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                }
            }
        }.resume()
    }
}
