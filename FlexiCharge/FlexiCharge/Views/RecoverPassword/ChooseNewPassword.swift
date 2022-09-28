//
//  ChooseNewPassword.swift
//  FlexiCharge
//
//  Created by Andrey Arronet on 2022-09-28.
//

import SwiftUI

struct ChooseNewPassword: View {
    @Binding var email: String
    @Binding var shouldPopToRootView: Bool
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var verificationCode: String = ""
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var accountAPI = AccountAPI()
    
    var body: some View {
        VStack {
            // Gray design at the top of the screen
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                Text("Choose New\nPassword")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .font(Font.system(size: 36, weight: .bold, design: .default))
            }
            VStack {
                Text("An email with a link to reset your password, has been sent to the following address…")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .padding(.top)
                    .padding(.horizontal, 2)
                Text(email)
                    .underline()
                    .padding(.vertical, 2)
                Spacer()
                SecureTextField(input: $password, placeholder: "New password", keyboardType: .default)
                Spacer()
                SecureTextField(input: $confirmPassword, placeholder: "Confirm password", keyboardType: .default)
                Spacer()
                RegularTextField(input: $verificationCode, placeholder: "Verification code", keyboardType: .default)
                Spacer()
                RegularButton(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    self.shouldPopToRootView = false
                }, text: "Back to log in", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                .padding()
                HStack {
                    Text("Didn’t get your email?")
                    Button(action: {
                        // TODO: send a new recover email
                        
                    }, label: {
                        Text("Send Again")
                            .foregroundColor(Color.primaryGreen)
                    })
                }
                .font(.subheadline)
                Spacer()
            }
            .frame(width: UsefulValues.screenWidth * 0.8)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}
