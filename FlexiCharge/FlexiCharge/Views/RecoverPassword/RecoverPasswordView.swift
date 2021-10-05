//
//  ForgotPasswordView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Binding var rootIsActive: Bool
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let emailPlaceholder: String = "Email"
    @State private var emailInput: String = ""
    @State private var selection: Int? = nil
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        VStack {
            // Gray design at the top of the screen
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("menu-arrow").rotationEffect(.degrees(90))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(alignment: .topLeading)
                    }
                    Spacer()
                    Text("Recover\nPassword")
                        .foregroundColor(.white)
                        .font(Font.system(size: 44, weight: .bold, design: .default))
                        .scaledToFill()
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image("menu-arrow")
                        .hidden()
                }.frame(width: screenWidth * 0.95, alignment: .center)
                .offset(y: -screenHeight * 0.03)
            }
            ZStack(alignment: .topLeading) {
                TextField(emailPlaceholder, text: $emailInput)
                    .keyboardType(.emailAddress)
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
            NavigationLink(destination: EmailSentView(email: $emailInput, shouldPopToRootView: $rootIsActive), tag: 1, selection: $selection) {
                // TODO: send email to recover  password
                RegularButton(action: {
                    self.selection = 1
                }, text: "Send", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
            .padding()
            Spacer()
        }.edgesIgnoringSafeArea(.top)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RecoverPasswordView_Previews: PreviewProvider {
    @Binding var rootIsActive: Bool
    static var previews: some View {
        RecoverPasswordView(rootIsActive: .constant(false))
    }
}
