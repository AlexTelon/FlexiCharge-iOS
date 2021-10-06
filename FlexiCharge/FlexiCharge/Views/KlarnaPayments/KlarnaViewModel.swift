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
    
    var client_token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjgyMzA1ZWJjLWI4MTEtMzYzNy1hYTRjLTY2ZWNhMTg3NGYzZCJ9.eyJzZXNzaW9uX2lkIjoiZThhMTNhM2YtOTYzOS0xZjMxLWI1NGUtNmQ4NzhmNmMyMjBlIiwiYmFzZV91cmwiOiJodHRwczovL2pzLnBsYXlncm91bmQua2xhcm5hLmNvbS9ldS9rcC9sZWdhY3kvcGF5bWVudHMiLCJkZXNpZ24iOiJrbGFybmEiLCJsYW5ndWFnZSI6InN2IiwicHVyY2hhc2VfY291bnRyeSI6IlNFIiwiZW52aXJvbm1lbnQiOiJwbGF5Z3JvdW5kIiwibWVyY2hhbnRfbmFtZSI6IllvdXIgYnVzaW5lc3MgbmFtZSIsInNlc3Npb25fdHlwZSI6IlBBWU1FTlRTIiwiY2xpZW50X2V2ZW50X2Jhc2VfdXJsIjoiaHR0cHM6Ly9ldS5wbGF5Z3JvdW5kLmtsYXJuYWV2dC5jb20iLCJleHBlcmltZW50cyI6W3sibmFtZSI6ImluLWFwcC1zZGstbmV3LWludGVybmFsLWJyb3dzZXIiLCJ2YXJpYXRlIjoibmV3LWludGVybmFsLWJyb3dzZXItZW5hYmxlIiwicGFyYW1ldGVycyI6eyJ2YXJpYXRlX2lkIjoibmV3LWludGVybmFsLWJyb3dzZXItZW5hYmxlIn19LHsibmFtZSI6ImluLWFwcC1zZGstY2FyZC1zY2FubmluZyIsInZhcmlhdGUiOiJjYXJkLXNjYW5uaW5nLWVuYWJsZSIsInBhcmFtZXRlcnMiOnsidmFyaWF0ZV9pZCI6ImNhcmQtc2Nhbm5pbmctZW5hYmxlIn19XX0.GU5E-BGTtpv22TcBZYMevlqfmuhX1ive774gmSVQJ91DwHD7MTgnqAMjk4TXtqCOflJ2xHCc19U6dkVRdRBjK87rENo60s8VRmicX2SC95y7QP-wzSaDkAn3xYZb5Y-Yuqubqap9eXu-rfrmTHytEMKTCSHe3YoUsiVg2EvKFE_Dw8bxvdIbHtDa-qF0KMCQSv6HAYsgtQWxpnnVv5AsrO7IbqP6VO7_URl_98USSpYdjKjr-Vu2aSKRfLpRmuuft6ETXp8O1IdmMy0IchQxCUeMR7jKHe2HhrxTqP82kzRlID-pTW6ezpX0-k1dhzo7wCqGgzpRMwrS2XdPOf2EwA"
    
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
        
        self.paymentView = KlarnaPaymentView(category: "pay_over_time", eventListener: self)
        self.paymentView!.initialize(clientToken: client_token, returnUrl: URL(string:"flexiChargeUrl://")!)
    }
}


extension KlarnaSDKIntegration: KlarnaPaymentEventListener {
    func klarnaInitialized(paymentView: KlarnaPaymentView) {
        viewControllerDelegate?.displayPaymentView()
        paymentView.load()
    }
    
    func klarnaLoaded(paymentView: KlarnaPaymentView) {}
    
    func klarnaLoadedPaymentReview(paymentView: KlarnaPaymentView) {}
    
    func klarnaAuthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?, finalizeRequired: Bool) {
        //        authorizationToken = authToken
    }
    
    func klarnaReauthorized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        //        authorizationToken = authToken
    }
    
    func klarnaFinalized(paymentView: KlarnaPaymentView, approved: Bool, authToken: String?) {
        //        authorizationToken = authToken
    }
    
    func klarnaResized(paymentView: KlarnaPaymentView, to newHeight: CGFloat) {
        print("KlarnaPaymentViewDelegate paymentView resizedToHeight: \(newHeight)")
    }
    
    func klarnaFailed(inPaymentView paymentView: KlarnaPaymentView, withError error: KlarnaPaymentError) {
        print("KlarnaPaymentViewDelegate paymentView failedWithError: \(error.debugDescription)")
    }
}


