//
//  ChargerRowView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-17.
//

import SwiftUI

struct ChargerRowView: View {
    @Binding var chargerHub: ChargerHubExt
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(Color.primaryDarkGray)
                .frame(height: 50)
            VStack(alignment: .leading) {
                HStack {
                    Text(chargerHub.name)
                    Spacer()
                    Text("100m")
                }
                HStack {
                    if chargerHub.chargers.count == 0 {
                        Text("No Chargers Available")
                            .foregroundColor(Color.primaryRed)
                            .font(.caption)
                            .padding(.top, 1)
                    } else {
                        ForEach(1...chargerHub.chargers.count, id: \.self) { _ in
                            Image("cable-light")
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
            ChargerRowView(chargerHub: .constant(ChargerHubExt(chargePointID: 9, name: "Jönköping", location: [0, 0], price: "99", klarnaReservationAmount: 300, chargers: [Charger(chargerID: 999999, location: [0, 0], chargePointID: 99, serialNumber: "!€%€/€%=DK=H=€", status: "Available")])))
        }
    }
}
