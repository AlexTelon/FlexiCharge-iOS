//
//  ChargerAPI.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-22.
//

import Foundation
import Combine
import SwiftUI

struct ChargerTest: Decodable, Identifiable {
    var chargerID: Int
    var location: [CGFloat]
    var chargePointID: Int
    var serialNumber: String
    var status: Int
    
    var id: Int {
        chargerID
    }
}

class ChargerAPI {
    var didChange = PassthroughSubject<ChargerAPI, Never>()
    var result = [ChargerTest]() {
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
                self.result = decodedData
            }
            print(decodedData)
        }.resume()
    }
    
    func beginCharging(chargerID: Int) {
        guard let url = URL(string: "http://54.220.194.65:8080/chargers/" + String(chargerID)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: Int] = [
            "status": 0,
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
    
    func stopCharging(chargerID: Int) {
        guard let url = URL(string: "http://54.220.194.65:8080/chargers/" + String(chargerID)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: Int] = [
            "status": 1,
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

struct ChargerResult: Decodable {
    var results: [ChargerTest]
}
