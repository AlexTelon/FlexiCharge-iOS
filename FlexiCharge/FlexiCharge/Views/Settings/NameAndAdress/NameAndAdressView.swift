//
//  InvoicesView.swift
//  FlexiCharge
//
//  Created by Sandra Nissan on 2022-09-14.
//

import SwiftUI
import Foundation

struct NameAndAdressView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var easeOutAnimation: Animation {
        Animation.easeOut
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                HStack (alignment: .center) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("menu-arrow").rotationEffect(.degrees(90))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Name And Adress")
                        .foregroundColor(.white)
                        .font(Font.system(size: 40, weight: .bold, design: .default))
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    Spacer()
                    //Very nice way to center text
                    Text("|||||||").hidden()
                }
                .frame(width: UsefulValues.screenWidth * 0.8)
            }
            Spacer()
            Text("Click here to view or change your name and adress")
                .multilineTextAlignment(.center)
            
        } .edgesIgnoringSafeArea(.top)
        Spacer()
        .edgesIgnoringSafeArea(.top)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
       
}
