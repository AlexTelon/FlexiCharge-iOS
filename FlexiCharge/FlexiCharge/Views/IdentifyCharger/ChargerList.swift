//
//  ChargerList.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import SwiftUI

struct ChargerList: View {
    @Binding var isShowingListOfChargers: Bool
    @Binding var chargerIdInput: String
    @Binding var chargers: [Charger]
    @Binding var chargePoints: [ChargerHub]
    @Binding var chargePointsExt: [ChargerHubExt]
    let listHeight: CGFloat
    let rowHeight: CGFloat = 50 + 12
    @State var menuHeight: CGFloat = 0
    
    
    init(isShowingListOfChargers: Binding<Bool>, chargePoints: Binding<[ChargerHub]>, chargers: Binding<[Charger]>, chargerIdInput: Binding<String>, chargePointsExt: Binding<[ChargerHubExt]>) {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self._isShowingListOfChargers = isShowingListOfChargers
        self._chargerIdInput = chargerIdInput
        self.listHeight = UsefulValues.screenHeight / 4
        self._chargers = chargers
        self._chargePoints  = chargePoints
        self._chargePointsExt = chargePointsExt
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack {
                    VStack {
                        Button(action: {
                            isShowingListOfChargers.toggle()
                        }) {
                            Image("menu-arrow").rotationEffect(.degrees(isShowingListOfChargers ? 0 : 180))
                        }
                        Text("Chargers Near Me")
                            .foregroundColor(.white)
                            .opacity(isShowingListOfChargers ? 0 : 1)
                    }
                    .overlay(GeometryReader { proxy in
                        Color
                           .clear
                           .preference(key: ContentLengthPreference.self, value: proxy.size.height)
                      })
                    .onPreferenceChange(ContentLengthPreference.self) { value in
                            DispatchQueue.main.async {
                               self.menuHeight = value + 12
                            }
                          }
                    List {
                        ForEach($chargePointsExt) { chargePointExt in
                            ZStack {
                                NavigationLink(destination: ChargerHubView(chargePointExt: chargePointExt, chargerIdInput: $chargerIdInput, isShowingListOfChargers: $isShowingListOfChargers)) {
                                    ChargerRowView(chargerHub: chargePointExt)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .listRowBackground(Color.primaryDarkGray)
                        .background(Color.primaryDarkGray)
                    }
                    .listStyle(InsetListStyle())
                }
            }
            .background(Color.primaryDarkGray)
            .navigationBarHidden(true)
            .animation(.none)
        }
        .frame(maxHeight: listHeight + menuHeight)
        .frame(height: isShowingListOfChargers ? CGFloat(chargePoints.count) * rowHeight > listHeight ? listHeight + menuHeight : CGFloat(chargePoints.count) * rowHeight + menuHeight : menuHeight)
    }
}

struct ChargerList_Previews: PreviewProvider {
    static var previews: some View {
        ChargerList(isShowingListOfChargers: .constant(true), chargePoints: .constant([ChargerHub(chargePointID: 9, name: "Name", location: [0, 0], price: "99", klarnaReservationAmount: 300)]), chargers: .constant([Charger(chargerID: 999999, location: [57.123, 57.123], chargePointID: 9, serialNumber: "jdiwamgoineawiug", status: "Available")]), chargerIdInput: .constant(""), chargePointsExt: .constant([ChargerHubExt(chargePointID: 9, name: "Name", location: [0, 0], price: "99", klarnaReservationAmount: 300, chargers: [Charger(chargerID: 999999, location: [0, 0], chargePointID: 99, serialNumber: "!€&/=€IVJA=€", status: "Available")])]))
    }
}

struct ContentLengthPreference: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
