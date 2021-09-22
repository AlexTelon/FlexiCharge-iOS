//
//  ChargerList.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import SwiftUI

struct ChargerList: View {
    @Binding var isShowingListOfChargers: Bool
    let screenHeight = UIScreen.main.bounds.size.height
    let listHeight: CGFloat
    let rowHeight: CGFloat = 50 + 12
    let chargerHubs: [ChargerHub] = [
        ChargerHub(id: 1, chargerLocationName: "Kungsgatan 1a, Jönköping", chargers: [
            Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
        ], distance: "400m"),
        ChargerHub(id: 2, chargerLocationName: "Asecs Röd Entre, Jönköping ", chargers: [
            Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
        ], distance: "1.1km"),
        ChargerHub(id: 3, chargerLocationName: "Sjukhusgatan, Jönköping", chargers: [
            Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
        ], distance: "600m"),
        ChargerHub(id: 4, chargerLocationName: "Asec Entre Am Jönköping", chargers: [
            Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
        ], distance: "1.2km"),
        ChargerHub(id: 4, chargerLocationName: "Asec Entre Am Jönköping", chargers: [
            Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
        ], distance: "1.2km")
    ]
    
    init(isShowingListOfChargers: Binding<Bool>) {
        UITableView.appearance().backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self._isShowingListOfChargers = isShowingListOfChargers
        self.listHeight = screenHeight / 4
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(.blue)
                    .edgesIgnoringSafeArea(.all)
                List {
                    ForEach(chargerHubs) { chargerHub in
                        ZStack {
                            NavigationLink(destination: ContentView()) {
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
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .navigationBarHidden(true)
            .animation(.none)
        }
        .frame(maxHeight: listHeight)
        .frame(height: isShowingListOfChargers ? CGFloat(chargerHubs.count) * rowHeight > listHeight ? listHeight : CGFloat(chargerHubs.count) * rowHeight : 0)
    }
}

struct ChargerList_Previews: PreviewProvider {
    static var previews: some View {
        ChargerList(isShowingListOfChargers: .constant(true))
    }
}
