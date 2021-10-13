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
    @Binding var isPresented: Bool
    @Binding var klarnaStatus: String
    @ObservedObject var sdkIntegration: KlarnaSDKIntegration = KlarnaSDKIntegration()

    init(isPresented: Binding<Bool>, klarnaStatus: Binding<String>) {
        self._isPresented = isPresented
        self._klarnaStatus = klarnaStatus
        sdkIntegration.getKlarnaSession()
    }
    
    var body: some View {
        VStack {
            Spacer()
            Image("klarna-logo-pink")
            Spacer()
            ProgressView().progressViewStyle(CircularProgressViewStyle())
            Spacer()
            Spacer()
        }.onChange(of: sdkIntegration.isKlarnaPaymentDone, perform: { _ in
            klarnaStatus = sdkIntegration.klarnaStatus
            print("identifier", klarnaStatus)
            isPresented = false
        })
    }
}


struct ViewController: UIViewControllerRepresentable, View {
    @Binding var isPresented: Bool
    @Binding var klarnaStatus: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController>) -> UIHostingController<KlarnaView> {
        return UIHostingController(rootView: KlarnaView(isPresented: $isPresented, klarnaStatus: $klarnaStatus))
    }

    func updateUIViewController(_ uiViewController: UIHostingController<KlarnaView>, context: UIViewControllerRepresentableContext<ViewController>) {
    }
}
