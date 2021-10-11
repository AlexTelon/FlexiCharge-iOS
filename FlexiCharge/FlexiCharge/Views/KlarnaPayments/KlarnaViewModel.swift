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
    
    var client_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyMzA1ZWJjLWI4MTEtMzYzNy1hYTRjLTY2ZWNhMTg3NGYzZCJ9.eyJzZXNzaW9uX2lkIjoiOGZhNzk0NGYtNTAwNC0xMzY2LWE2NmYtOTBlMzk4MTg1MzRmIiwiYmFzZV91cmwiOiJodHRwczovL2pzLnBsYXlncm91bmQua2xhcm5hLmNvbS9ldS9rcC9sZWdhY3kvcGF5bWVudHMiLCJkZXNpZ24iOiJrbGFybmEiLCJsYW5ndWFnZSI6InN2IiwicHVyY2hhc2VfY291bnRyeSI6IlNFIiwiZW52aXJvbm1lbnQiOiJwbGF5Z3JvdW5kIiwibWVyY2hhbnRfbmFtZSI6IllvdXIgYnVzaW5lc3MgbmFtZSIsInNlc3Npb25fdHlwZSI6IlBBWU1FTlRTIiwiY2xpZW50X2V2ZW50X2Jhc2VfdXJsIjoiaHR0cHM6Ly9ldS5wbGF5Z3JvdW5kLmtsYXJuYWV2dC5jb20iLCJleHBlcmltZW50cyI6W3sibmFtZSI6ImluLWFwcC1zZGstbmV3LWludGVybmFsLWJyb3dzZXIiLCJ2YXJpYXRlIjoibmV3LWludGVybmFsLWJyb3dzZXItZW5hYmxlIiwicGFyYW1ldGVycyI6eyJ2YXJpYXRlX2lkIjoibmV3LWludGVybmFsLWJyb3dzZXItZW5hYmxlIn19LHsibmFtZSI6ImluLWFwcC1zZGstY2FyZC1zY2FubmluZyIsInZhcmlhdGUiOiJjYXJkLXNjYW5uaW5nLWVuYWJsZSIsInBhcmFtZXRlcnMiOnsidmFyaWF0ZV9pZCI6ImNhcmQtc2Nhbm5pbmctZW5hYmxlIn19XX0.kmtnqPderO5-mfphr3nSbv9VkRJpUUz1C23EtCB-ZjxGTZVLkK0v_7_xRoStTXz3-ZGnykUFqZNhOyXa26TLob9sD_PRikDSMJBscI4DrlCO7M52t-D-taITXC5NxRVigeTAQyptLA9ZVpc-YeD25fEyzbPlLa4MlxhxLqVztKrYhJixttmfI-RhuqIpWz3MjTpbNTkvN5LjLTBVUv0j2O-OlRSXjIAF74U4ngOrJpquEUbBWKnj8W5gKHbltaDXn1GFysDLkOIXLFXVhkaQPV4ZnRVfpinEwHNKhupugD2m07ecoKv9Rah4y4JTrexUHuAz4IB7yFJvsIDhlecgkQ"
    
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
        self.paymentView!.initialize(clientToken: client_token, returnUrl: URL(string:"flexiChargeUrl://")!)
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
        }    }
    
    func klarnaResized(paymentView: KlarnaPaymentView, to newHeight: CGFloat) {
        print("KlarnaPaymentViewDelegate paymentView resizedToHeight: \(newHeight)")
    }
    
    func klarnaFailed(inPaymentView paymentView: KlarnaPaymentView, withError error: KlarnaPaymentError) {
        print("KlarnaPaymentViewDelegate paymentView failedWithError: \(error.debugDescription)")
    }
}


