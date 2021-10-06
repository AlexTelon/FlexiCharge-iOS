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

//TODO: Starta sdkIntegration.createPaymentView() när viewn laddar in
//starta klarna view när kanppen trycks på med displayPaymentView()
// embeded funktionen finns i filen KlarnaUiViewViewExtensions

struct KlarnaView: View {
    var body: some View {
        VStack {
            Text("Hello World!")
            Button(action: {
                //display paiment view efter när knappen är tryckt
            }, label: {
                Text("Button")
            })
        }
    }
}


struct UIViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<UIViewController>) -> UIHostingController<KlarnaView> {
        return UIHostingController(rootView: KlarnaView())
    }
    
    func updateUIViewController(_ uiViewController: UIHostingController<KlarnaView>, context: UIViewControllerRepresentableContext<UIViewController>) {
    }
    
    // MARK: - IBOutlets
    private weak var activityIndicator: UIActivityIndicatorView!
    private weak var buttonStackView: UIStackView!
    
    // MARK: - Properties
    private var sdkIntegration: KlarnaSDKIntegration = KlarnaSDKIntegration()

    
    func createNewOrder() {
        sdkIntegration.createPaymentView()
    }
    
    func displayPaymentView() {
        //        DispatchQueue.main.async { [weak self] in
        //            guard let self = self else {
        //                fatalError("`self` does not exist!")
        //            }
        self.activityIndicator.stopAnimating()
        if let paymentView = self.sdkIntegration.paymentView {
        self.embed(subview: paymentView, toBottomAnchor: self.buttonStackView.topAnchor)
        }
        else {
            print("ViewController displayPaymentView: Payment view does not exist!")
        }
    }
}
    
