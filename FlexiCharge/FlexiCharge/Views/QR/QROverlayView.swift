//
//  QROverlayView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-15.
//

import SwiftUI

struct QROverlayView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let gridNetY: ClosedRange<Int> = 0...3
    let gridNetX: ClosedRange<Int> = 0...2
    
    var body: some View {
        ZStack {
            VStack {
                ForEach(gridNetY, id: \.self) { y in
                    HStack {
                        ForEach(gridNetX, id: \.self) { x in
                            Rectangle()
                                .fill(Color.black)
                                .frame(width: screenWidth / 2, height: screenWidth / 2)
                                .opacity(y == 1 && x == 1 ? 0 : 0.7)
                                .padding(-4)
                        }
                    }
                }
            }
            Text("Scan QR code on Charger")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                .opacity(1)
                .multilineTextAlignment(.center)
        }
    }
}

struct QROverlayView_Previews: PreviewProvider {
    static var previews: some View {
        QROverlayView()
    }
}
