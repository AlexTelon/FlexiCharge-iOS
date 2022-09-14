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
    @Published var isLoggedIn : Bool = false
    
    init() {
        
    }
    
    func registerAccount(username: String, password: String, email: String, firstName: String, surName: String, completion: @escaping (String)->Void) -> Void {
        guard let url = URL(string: "http://18.202.253.30:8080/auth/sign-up") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: String] = [
            "username": "Dargon",
            "password": "Kalleballe123.",
            "email": "kalle@sharklasers.com",
            "name": "kalle",
            "family_name": "Kung"
        ]
        print(jsonDictionary)
        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if error != nil {
                return
            }
            print("No errors")
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 201 else {
                    print(responseCode)
                    let responseCodeAsString = String(responseCode)
                    completion(responseCodeAsString)
                    return
                }
                print(responseCode)
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    let responseDataAsString = responseJSONData as! String
                    print("ResponseDataString")
                    print(responseDataAsString)
                    completion(responseDataAsString)
                }
            }
        }.resume()
        print("Data:", data)
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
