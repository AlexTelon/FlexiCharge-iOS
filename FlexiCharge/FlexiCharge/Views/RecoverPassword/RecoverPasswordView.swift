//
//  ForgotPasswordView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//

import SwiftUI

struct RecoverPasswordView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let emailPlaceholder: String = "Email"
    @State private var emailInput: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                Text("Recover\nPassword")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(Font.system(size: 36, weight: .bold, design: .default))
            }
            ZStack(alignment: .topLeading) {
                TextField(emailPlaceholder, text: $emailInput)
                    .frame(width: screenWidth * 0.8, height: inputHeight)
                    .offset(x: 8)
                    .overlay(RoundedRectangle(cornerRadius: inputCornerRadius).stroke())
                Text(emailPlaceholder)
                    .foregroundColor(.black)
                    .padding(.horizontal, 5)
                    .background(Color.white)
                    .offset(x: 10, y: -10)
                    .opacity(emailInput.count > 0 ? 1 : 0)
            }
            Text("Please provide the email address you used to register.\nWe will send you an email\nwith a link to reset your password")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.top)
                .padding(.horizontal, 2)
                .frame(width: screenWidth * 0.8)
            Spacer()
            Spacer()
            Button(action: {
                
            }, label: {
                Text("Send")
                    .font(Font.system(size: 20,weight: .bold, design: .default))
            })
            .frame(width: screenWidth * 0.8, height: 48)
            .background(Color(red: 0.47, green: 0.74, blue: 0.46))
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding()
            Spacer()
        }.edgesIgnoringSafeArea(.top)
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        RecoverPasswordView()
    }
}
