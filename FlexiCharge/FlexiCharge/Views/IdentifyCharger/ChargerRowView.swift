//
//  ChargerRowView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import SwiftUI

struct ChargerRowView: View {
    var chargerHub: ChargerHub
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                .frame(height: 50)
            VStack(alignment: .leading) {
                HStack {
                    Text(chargerHub.chargerLocationName)
                    Spacer()
                    Text(chargerHub.distance)
                }
                HStack {
                    if chargerHub.chargers.count == 0 {
                        Text("No Chargers Available")
                            .foregroundColor(Color(red: 0.94, green: 0.38, blue: 0.28))
                            .font(.caption)
                            .padding(.top, 1)
                    } else {
                        ForEach(1...chargerHub.chargers.count, id: \.self) { _ in
                            Image("Cable")
                                .resizable()
                                .frame(width: 22, height: 20)
                                .padding(.top, -4)
                                .padding(.trailing, -2)
                        }
                    }
                }
            }
        }
        .font(Font.system(size: 17))
        .foregroundColor(.white)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
    }
}

struct ChargerRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChargerRowView(chargerHub: ChargerHub(id: 1, chargerLocationName: "Kungsgatan 1a, Jönköping", chargers: [
                Charger(id: 123456, type: 2, kW: 7, krPerkWh: 3.00, availability: "Available")
            ], distance: "400m"))
        }
    }
}
