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

    private(set) var paymentView: KlarnaPaymentView?
    
    var result: AnyObject

    init() {
        
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
                    
                    
                    self.result = responseJSONData as AnyObject
                }
            }
        }.resume()
    }
    
    struct KlarnaSession: Decodable {
        var transactionID: Int?
        var userID: String?
        var chargerID: Int?
        var pricePerKwh: String?
        var session_id: String?
        var client_token: String?
        var payment_method_categories: [PaymentMethod?]?
        var paymentConfirmed: Bool?
        var isKlarnaPayment: Bool?
        var timestamp: Int?
        var kwhTransfered: Int?
        var currentChargePercentage: Int?
        var paymentID: Int?
    }
    struct PaymentMethod: Decodable {
        var identifier: String?
        var name: String?
        var assetsUrl: [AssetUrls?]?
    }
    struct AssetUrls: Decodable {
        var descriptive: String?
        var standard: String?
    }
    
    public func createPaymentView() {
        //        guard let clientToken = clientToken else {
        //            print("SDKIntegration createPaymentView: Client token was not set!")
        //            return
        //        }
        
        //        guard !categories.isEmpty else {
        //            print("SDKIntegration createPaymentView: No payment method categories returned!")
        //            return
        //        }
        
        //        let category = self.categories[currentCategoryIndex]
        //
        //        DispatchQueue.main.async { [weak self] in
        //            guard let self = self else {
        //                fatalError("`self` does not exist!")
        //            }
        
        self.paymentView = KlarnaPaymentView(category: "pay_now", eventListener: self)
        self.paymentView!.initialize(clientToken: , returnUrl: URL(string:"flexiChargeUrl://")!)
    }
}


extension KlarnaSDKIntegration: KlarnaPaymentEventListener {
    func klarnaInitialized(paymentView: KlarnaPaymentView) {
        //viewControllerDelegate?.displayPaymentView()
        paymentView.load()
        print("TEST")
    }
    
    
    func klarnaLoaded(paymentView: KlarnaPaymentView) {
        print("Wheyoow")
        paymentView.authorize()
    }
    
    func klarnaLoadedPaymentReview(paymentView: KlarnaPaymentView) {}
    
    func klarnaAuthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?, finalizeRequired: Bool) {
        if approved == true {
            // the authorization was successful
        } else {
            // user is not approved or might require finalization
        }

        if let token = authToken {
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

