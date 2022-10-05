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
    @State var verificationCode: String = ""
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var accountAPI = AccountAPI()
    @State var validationText = ""
    @State var validationPasswordText = ""
    @State var validationVerificationCodeText = ""
    @State var selection: Int? = nil
    
    var body: some View {
        VStack {
            // Gray design at the top of the screen
            ZStack {
                Image("top-tilted-rectangle")
                    .resizable()
                    .scaledToFit()
                HStack{
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("menu-arrow").rotationEffect(.degrees(90))
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(alignment: .topLeading)
                    }
                    Spacer()
                    Text("Choose New\nPassword")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .font(Font.system(size: 36, weight: .bold, design: .default))
                    Spacer()
                    Image("menu-arrow")
                        .hidden()
                }.frame(width: UsefulValues.screenWidth * 0.95, alignment: .center)
                .offset(y: -UsefulValues.screenHeight * 0.03)
            }
            VStack {
                Group {
                    Text("An email with a link to reset your password, has been sent to the following address…")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                        .padding(.top)
                        .padding(.horizontal, 2)
                    Text(email)
                        .underline()
                        .padding(.vertical, 2)
                }
                Spacer()
                Group{
                    SecureTextField(input: $password, placeholder: "New password", keyboardType: .default)
                        .foregroundColor(
                            password == "" ? Color.black : validatePassword(password: password) == "" ? Color.black : Color.primaryRed
                        )
                        .onChange(of: password) { newValue in
                            validationPasswordText = validatePassword(password: newValue)
                        }
                    Text("\(validationPasswordText)")
                        .foregroundColor(.red)
                        .padding(.bottom)
                    Spacer()
                    RegularTextField(input: $verificationCode, placeholder: "Verification code", keyboardType: .default)
                        .foregroundColor(
                            verificationCode == "" ? Color.black : validateVerificationCode(verificationCode: verificationCode) == "" ? Color.black : Color.primaryRed
                        )
                        .onChange(of: verificationCode) { newValue in
                            validationVerificationCodeText = validateVerificationCode(verificationCode: verificationCode)
                        }
                    Text("\(validationVerificationCodeText)")
                        .foregroundColor(.red)
                        .padding(.bottom)
                }
                Spacer()
                Text("\(validationText)")
                    .foregroundColor(.red)
                    .padding(.bottom)
                NavigationLink(destination: LoginView(), tag: 2, selection: $selection){
                    RegularButton(action: {
                        accountAPI.confirmForgotPassword(email: email, password: password, verificationCode: verificationCode) { response in
                            if response == "200"{
                                selection = 2
                            }
                            else{
                                validationText = response
                                print("Misslyckades")
                            }
                        }
                    }, text: "Confirm password", foregroundColor: Color.white, backgroundColor: validatePassword(password: password) == "" && validateVerificationCode(verificationCode: verificationCode) == "" ? Color.primaryGreen : Color.primaryDarkGray)
                }
                .disabled(validatePassword(password: password) != "" && validateVerificationCode(verificationCode: verificationCode) != "")
                .padding()
                HStack {
                    Text("Didn’t get your email?")
                    Button(action: {
                        accountAPI.forgotPassword(email: email) { response in
                            if response != "200"{
                                validationText = response
                                print("Misslyckades")
                            }
                        }
                        
                    }, label: {
                        Text("Send Again")
                            .foregroundColor(Color.primaryGreen)
                    })
                }
                .font(.subheadline)
            }
            .frame(width: UsefulValues.screenWidth * 0.8)
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}
