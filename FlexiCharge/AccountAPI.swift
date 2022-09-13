//
//  AccountAPI.swift
//  FlexiCharge
//
//  Created by Sandra Nissan on 2022-09-13.
//

import Foundation
import Combine
import SwiftUI

class AccountAPI : ObservableObject {
    @Published var isLoggedIn : Bool = true
    
    init() {
        
    }
    
    func beginCharging(chargerID: Int, completion: @escaping (String) -> Void) -> Void {
        guard let url = URL(string: "http://54.220.194.65:8080/reservations/" + String(chargerID)) else { return }
        
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
}
