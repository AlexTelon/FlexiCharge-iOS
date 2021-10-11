//
//  ForgotPasswordView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Binding var rootIsActive: Bool

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
                }.frame(width: UsefulValues.screenWidth * 0.95, alignment: .center)
                .offset(y: -UsefulValues.screenHeight * 0.03)
            }
            RegularTextField(input: $emailInput, placeholder: "Email", keyboardType: .emailAddress)
            Text("Please provide the email address you used to register.\nWe will send you an email\nwith a link to reset your password")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.top)
                .padding(.horizontal, 2)
                .frame(width: UsefulValues.screenWidth * 0.8)
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
