//
//  ChargerHubView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-25.
//

import SwiftUI

struct ChargerInfoBox: View {
    var charger: Charger
    var chargerStatusColor = [StatusConstants.AVAILABLE: Color.primaryGreen, StatusConstants.PREPARING: Color.gray, StatusConstants.CHARGING: Color.primaryRed, StatusConstants.SUSPENDEDEVSE: Color.primaryDarkGray, StatusConstants.SUSPENDEDEV: Color.primaryDarkGray, StatusConstants.FINISHING: Color.primaryDarkGray, StatusConstants.RESERVED: Color.primaryDarkGray, StatusConstants.UNAVAILABLE: Color.primaryDarkGray, StatusConstants.FAULTED: Color.primaryDarkGray]
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
    @Binding var chargePointExt: ChargerHubExt
    @Binding var chargerIdInput: String
    @Binding var isShowingListOfChargers: Bool
    
    @State var chargerBoxMinX: CGFloat = 0
    @State var chargerBoxMaxX: CGFloat = 0
    @State private var boxMinX: CGFloat = 0
    @State private var boxMaxX: CGFloat = 0
    @State private var selectedCharger: Charger?
    @State private var selectedPayment: String?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                Text(chargePointExt.name)
                    .foregroundColor(.white)
                    .font(Font.system(size: 17, design: .default))
                    .scaledToFill()
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                Spacer()
            }.frame(width: UsefulValues.screenWidth * 0.82)
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
                    ForEach(chargePointExt.chargers) { charger in
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
            HStack(spacing: UsefulValues.screenWidth * 0.04) {
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
            .frame(maxWidth: UsefulValues.screenWidth * 0.82)
            .foregroundColor(.black)
            Spacer()
        }
        .onChange(of: isShowingListOfChargers, perform: { _ in
            self.presentationMode.wrappedValue.dismiss()
        })
        .background(Color.primaryDarkGray)
        .navigationBarHidden(true)
    }
}


struct ChargerHubView_Previews: PreviewProvider {
    static var previews: some View {
        ChargerHubView(chargePointExt: .constant(ChargerHubExt(chargePointID: 9, name: "Jönköping", location: [0, 0], price: "99", klarnaReservationAmount: 300, chargers: [Charger(chargerID: 999999, location: [0, 0], chargePointID: 99, serialNumber: "!)%I&)€JHI", status: "Available")])), chargerIdInput: .constant(""), isShowingListOfChargers: .constant(false))
    }
}

struct PaymentOptions {
    static let PAY_NOW = "PAY_NOW"
    static let INVOICE = "INVOICE"
}
