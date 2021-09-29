//
//  ChargerList.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import SwiftUI

struct ChargerList: View {
    @Binding var isShowingListOfChargers: Bool
    var chargers: [ChargerTest]
    let screenHeight = UIScreen.main.bounds.size.height
    let listHeight: CGFloat
    let rowHeight: CGFloat = 50 + 12
    let chargerHubs: [ChargerHub]
    @State var menuHeight: CGFloat = 0
    
    
    init(isShowingListOfChargers: Binding<Bool>, chargers: [ChargerTest]) {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self._isShowingListOfChargers = isShowingListOfChargers
        self.listHeight = screenHeight / 4
        self.chargers = chargers
        self.chargerHubs  = [
            ChargerHub(id: 2, chargerLocationName: "Asecs Röd Entre, Jönköping", chargers: self.chargers, distance: "1.1km"),
            ChargerHub(id: 3, chargerLocationName: "Sjukhusgatan, Jönköping", chargers: self.chargers, distance: "600m"),
            ChargerHub(id: 4, chargerLocationName: "Asec Entre Am Jönköping", chargers: self.chargers, distance: "1.2km"),
            ChargerHub(id: 4, chargerLocationName: "Asec Entre Am Jönköping", chargers: self.chargers, distance: "1.2km")
        ]
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
                        ForEach(chargerHubs) { chargerHub in
                            ZStack {
                                NavigationLink(destination: ChargerHubView(chargerHub: chargerHub)) {
                                    ChargerRowView(chargerHub: chargerHub)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                        .listRowBackground(Color(red: 0.2, green: 0.2, blue: 0.2))
                        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
                    }
                    .listStyle(InsetListStyle())
                }
            }
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .navigationBarHidden(true)
            .animation(.none)
        }
        .frame(maxHeight: listHeight + menuHeight)
        .frame(height: isShowingListOfChargers ? CGFloat(chargerHubs.count) * rowHeight > listHeight ? listHeight + menuHeight : CGFloat(chargerHubs.count) * rowHeight + menuHeight : menuHeight)
    }
}

struct ChargerList_Previews: PreviewProvider {
    static var previews: some View {
        ChargerList(isShowingListOfChargers: .constant(true), chargers: [ChargerTest(chargerID: 999999, location: [57.123, 57.123], chargePointID: 9, serialNumber: "jdiwamgoineawiug", status: 1)])
    }
}

struct ContentLengthPreference: PreferenceKey {
    var value2: CGFloat
    static var defaultValue: CGFloat { 0 }
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
