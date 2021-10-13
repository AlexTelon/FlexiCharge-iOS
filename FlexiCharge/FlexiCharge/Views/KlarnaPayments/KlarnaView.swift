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
    @Binding var klarnaMessage: String
    @ObservedObject var sdkIntegration: KlarnaSDKIntegration = KlarnaSDKIntegration()

    init(isPresented: Binding<Bool>, klarnaMessage: Binding<String>) {
        self._isPresented = isPresented
        self._klarnaMessage = klarnaMessage
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
            klarnaMessage = sdkIntegration.klarnaMessage
            print("identifier", klarnaMessage)
            isPresented = false
        })
    }
}


struct ViewController: UIViewControllerRepresentable, View {
    @Binding var isPresented: Bool
    @Binding var klarnaMessage: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController>) -> UIHostingController<KlarnaView> {
        return UIHostingController(rootView: KlarnaView(isPresented: $isPresented, klarnaMessage: $klarnaMessage))
    }

    func updateUIViewController(_ uiViewController: UIHostingController<KlarnaView>, context: UIViewControllerRepresentableContext<ViewController>) {
    }
}
