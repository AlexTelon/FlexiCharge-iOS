//
//  ChargerHubView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-25.
//

import SwiftUI

struct ChargerInfoBox: View {
    var charger: ChargerTest
    var chargerStatusColor = [StatusConstants.AVAILABLE: Color.green, StatusConstants.PREPARING: Color.gray, StatusConstants.CHARGING: Color.red, StatusConstants.SUSPENDEDEVSE: Color.gray, StatusConstants.SUSPENDEDEV: Color.gray, StatusConstants.FINISHING: Color.gray, StatusConstants.RESERVED: Color.gray, StatusConstants.UNAVAILABLE: Color.gray, StatusConstants.FAULTED: Color.gray]
    @State public var boxHeight: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.white)
                .frame(height: boxHeight)
            
            HStack(spacing: 20) {
                VStack {
                    Image("cable-dark")
                    Text("Type 2").offset(y: -5)
                }
                VStack(alignment: .leading, spacing: -3) {
                    Text(String(charger.chargerID))
                    Text("AC 7kW")
                    Text("3.00 kr/kWh")
                    Text(charger.status)
                        .foregroundColor(chargerStatusColor[charger.status])
                        .padding(.top, 4)
                }
            }.overlay(GeometryReader { proxy in
                Color
                    .clear
                    .preference(key: ContentLengthPreference.self, value: proxy.size.height)
            })
            .onPreferenceChange(ContentLengthPreference.self) { value in
                DispatchQueue.main.async {
                    self.boxHeight = value + 12
                }
            }
            .font(.system(size: 11))
            .foregroundColor(.black)
            .padding(5)
        }.frame(height: 60)
    }
}

struct ChargerHubView: View {
    var chargerHub: ChargerHub
    @Binding var chargerIdInput: String
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @State var chargerBoxMinX: CGFloat = 0
    @State var chargerBoxMaxX: CGFloat = 0
    @State private var boxMinX: CGFloat = 0
    @State private var boxMaxX: CGFloat = 0
    @State private var selectedCharger: ChargerTest?
    @State private var selectedPayment: String?
    @Environment(\.presentationMode) /*static*/ var presentationMode: Binding<PresentationMode>
    // Static above is for a feature in the future
    
    var body: some View {
        VStack {
            Text("").hidden()
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image("menu-arrow").rotationEffect(.degrees(90))
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .frame(alignment: .leading)
                }
                Spacer()
                Text(chargerHub.chargerLocationName)
                    .foregroundColor(.white)
                    .font(Font.system(size: 17, design: .default))
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Spacer()
            }.frame(width: screenWidth * 0.82)
            HStack {
                ZStack {
                    Image("location-pin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 18)
                        .foregroundColor(Color.primaryGreen)
                        .overlay(Color.primaryGreen.blendMode(.sourceAtop))
                }
                .drawingGroup(opaque: false)
                Text("Current Location")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primaryGreen)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: boxMinX)
            }
            .padding(.top, 7)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(chargerHub.chargers) { charger in
                        ChargerInfoBox(charger: charger)
                            .border(selectedCharger?.chargerID == charger.chargerID ? Color.primaryGreen : Color.clear, width: 3)
                            .cornerRadius(5)
                            .onTapGesture {
                                self.selectedCharger = charger
                                self.chargerIdInput = String(charger.chargerID)
                            }
                    }
                }
                .overlay(GeometryReader { proxy in
                    let offsetMin = proxy.frame(in: .named("scroll")).minX
                    let offsetMax = proxy.frame(in: .named("scroll")).maxX
                    let minXOffset = chargerBoxMinX - offsetMin
                    let maxXOffset = chargerBoxMaxX - offsetMax
                    HStack {
                        Image("menu-arrow")
                            .padding(4)
                            .rotationEffect(Angle(degrees: 90))
                            .frame(maxHeight: .infinity)
                            .foregroundColor(.red)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.20, green: 0.20, blue: 0.20), .clear]), startPoint: .leading, endPoint: .trailing))
                            .opacity(offsetMin < chargerBoxMinX ? 1 : 0)
                            .offset(x: minXOffset)
                        Spacer()
                        Image("menu-arrow")
                            .padding(4)
                            .rotationEffect(Angle(degrees: -90))
                            .frame(maxHeight: .infinity)
                            .foregroundColor(.red)
                            .background(LinearGradient(gradient: Gradient(colors: [.clear, Color(red: 0.20, green: 0.20, blue: 0.20)]), startPoint: .leading, endPoint: .trailing))
                            .opacity(offsetMax > chargerBoxMaxX ? 1 : 0)
                            .offset(x: maxXOffset)
                    }
                })
            }
            .overlay(GeometryReader { proxy in
                let offsetMin = proxy.frame(in: .named("scroll")).minX
                Color.clear.preference(key: ContentLengthPreference.self, value: offsetMin)
            })
            .onPreferenceChange(ContentLengthPreference.self) { value in
                self.chargerBoxMinX = value
            }
            .overlay(GeometryReader { proxy in
                let offsetMax = proxy.frame(in: .named("scroll")).maxX
                Color.clear.preference(key: ContentLengthPreference.self, value: offsetMax)
            })
            .onPreferenceChange(ContentLengthPreference.self) { value in
                self.chargerBoxMaxX = value
            }
            Text("").hidden()
            Text("Payment")
                .font(.system(size: 17))
                .foregroundColor(.white)
            HStack(spacing: screenWidth * 0.04) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                    Image("klarna-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 30)
                }
                .frame(maxHeight: 48)
                .border(selectedPayment == PaymentOptions.PAY_NOW ? Color.primaryGreen : Color.clear, width: 3)
                .cornerRadius(5)
                .onTapGesture {
                    self.selectedPayment = PaymentOptions.PAY_NOW
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                    VStack {
                        Text("Invoice")
                            .font(.system(size: 18))
                        Text("Invoice")
                            .font(.system(size: 12))
                    }
                }
                .frame(maxHeight: 48)
                .border(selectedPayment == PaymentOptions.INVOICE ? Color.primaryGreen : Color.clear, width: 3)
                .cornerRadius(5)
                .onTapGesture {
                    self.selectedPayment = PaymentOptions.INVOICE
                }
            }
            .frame(maxWidth: screenWidth * 0.82)
            .foregroundColor(.black)
            Spacer()
        }
        .background(Color.primaryDarkGray)
        .navigationBarHidden(true)
    }
}


struct ChargerHubView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerHubView(chargerHub: ChargerHub(id: 2, chargerLocationName: "Asecs Röd Entre, Jönköping ", chargers: [ChargerTest(chargerID: 111111, location: [12.12, 12.12], chargePointID: 1, serialNumber: "miabsginaow", status: "Occupied")], distance: "1.1km"), chargerIdInput: .constant(""))
    }
}

struct PaymentOptions {
    static let PAY_NOW = "PAY_NOW"
    static let INVOICE = "INVOICE"
}
