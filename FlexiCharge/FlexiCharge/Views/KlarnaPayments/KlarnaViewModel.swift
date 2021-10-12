//
//  KlarnaViewModel.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-27.
//

import Foundation
import KlarnaMobileSDK

final class KlarnaSDKIntegration {
    weak var viewControllerDelegate: ViewControllerDelegate?
    @Published var isKlarnaPaymentDone: Bool = false
    private(set) var paymentView: KlarnaPaymentView?
    
    var result: AnyObject?
    
    init() {
        
    }

    func getKlarnaSession() {
        
        guard let url = URL(string: "http://54.220.194.65:8080/transactions/session") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: Any] = [
            "userID": "2i3h52-3kn34k6-2k3n5",
            "chargerID": 100002
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {
                guard responseCode == 201 else {
                    print("Invalid response code: \(responseCode)")
                    return
                }
                
                if let responseJSONData = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments) {
                    print("Response JSON data = \(responseJSONData)")
                    
                    
                    DispatchQueue.main.async {
                        self.result = responseJSONData as AnyObject
                        self.createPaymentView()
                    }
                }
            }
        }.resume()
    }
    
    public func createPaymentView() {

        self.paymentView = KlarnaPaymentView(category: "pay_now", eventListener: self)
        self.paymentView!.initialize(clientToken: result!["client_token"] as! String, returnUrl: URL(string:"flexiChargeUrl://")!)
    }
    
    func SendKlarnaToken(transactionID: Int, authorization_token: String){
        guard let url = URL(string: "http://54.220.194.65:8080/transactions/order") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        let jsonDictionary: [String: Any] = [
            "transactionID": transactionID,
            "authorization_token": authorization_token
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted)
        
        URLSession.shared.uploadTask(with: request, from: data) { (responseData, response, error) in
            if let error = error {
                print("Error making POST request: \(error.localizedDescription)")
                return
            }
            
            
            if let responseCode = (response as? HTTPURLResponse)?.statusCode, let responseData = responseData {

                guard responseCode == 201 else {
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


extension KlarnaSDKIntegration: KlarnaPaymentEventListener {
    func klarnaInitialized(paymentView: KlarnaPaymentView) {
        //viewControllerDelegate?.displayPaymentView()
        paymentView.load()
    }
    
    
    func klarnaLoaded(paymentView: KlarnaPaymentView) {
        paymentView.authorize()
    }
    
    func klarnaLoadedPaymentReview(paymentView: KlarnaPaymentView) {
        
    }
    
    func klarnaAuthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?, finalizeRequired: Bool) {
        if approved == true {
            // the authorization was successful
        } else {
            // user is not approved or might require finalization
        }

        if let token = authToken {
            let transactionID = result!["transactionID"] as! Int
            SendKlarnaToken(transactionID: transactionID, authorization_token: token)
            
            // authorization is successful, backend may create order
        }
    }
    
    func klarnaReauthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        if approved == true {
            // the authorization was successful
        } else {
            // user is not approved or might require finalization
        }
        if let token = authToken {
            let transactionID = result!["transactionID"] as! Int
            SendKlarnaToken(transactionID: transactionID, authorization_token: token)
            // authorization is successful, backend may create order
        }
    }
    
    func klarnaFinalized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        if approved == true {
            // the finalization was successful
        } else {
            // user is not approved or might require finalization
        }
        if let token = authToken {
            let transactionID = result!["transactionID"] as! Int
            SendKlarnaToken(transactionID: transactionID, authorization_token: token)
            // finalization is successful, backend may create order
        }
    }
    
    func klarnaResized(paymentView: KlarnaPaymentView, to newHeight: CGFloat) {
        print("KlarnaPaymentViewDelegate paymentView resizedToHeight: \(newHeight)")
    }
    
    func klarnaFailed(inPaymentView paymentView: KlarnaPaymentView, withError error: KlarnaPaymentError) {
        print("KlarnaPaymentViewDelegate paymentView failedWithError: \(error.debugDescription)")
    }
}

