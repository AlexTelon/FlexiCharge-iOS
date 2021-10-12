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
    var isPresented: Binding<Bool>

    private var sdkIntegration: KlarnaSDKIntegration = KlarnaSDKIntegration()

    init(isPresented: Binding<Bool>) {
        self.isPresented = isPresented
        sdkIntegration.getKlarnaSession()
    }
    
    var body: some View {
        VStack {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
    }
}


struct ViewController: UIViewControllerRepresentable, View {
    @Binding var isPresented: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewController>) -> UIHostingController<KlarnaView> {
        return UIHostingController(rootView: KlarnaView(isPresented: $isPresented))
    }

    func updateUIViewController(_ uiViewController: UIHostingController<KlarnaView>, context: UIViewControllerRepresentableContext<ViewController>) {
    }
}
    
