//
//  KlarnaView.swift
//  FlexiCharge
//
//  Created by Daniel Göthe on 2021-09-27.
//
import UIKit
import SwiftUI
import KlarnaMobileSDK


public protocol ViewControllerDelegate: class {
    func displayPaymentView()
}


struct KlarnaView: View {
    private var sdkIntegration: KlarnaSDKIntegration = KlarnaSDKIntegration()

    init() {
        sdkIntegration.createPaymentView()
    }
    
    var body: some View {
        VStack {
            
        }
    }
}


struct ViewController: UIViewControllerRepresentable {


    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController>) -> UIHostingController<KlarnaView> {
        return UIHostingController(rootView: KlarnaView())
    }

    func updateUIViewController(_ uiViewController: UIHostingController<KlarnaView>, context: UIViewControllerRepresentableContext<ViewController>) {
    }
}
    
