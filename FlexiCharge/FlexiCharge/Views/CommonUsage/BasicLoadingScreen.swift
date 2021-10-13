//
//  BasicLoadingScreen.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-10-12.
//

import SwiftUI

struct BasicLoadingScreen: View {
    var imageName: String
    
    var body: some View {
        ZStack {
            Color.primaryLightGray.opacity(0.2)
            VStack {
                Spacer()
                Spacer()
                Image(imageName)
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}

struct BasicLoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        BasicLoadingScreen(imageName: "flexi-charge-logo-color")
    }
}
