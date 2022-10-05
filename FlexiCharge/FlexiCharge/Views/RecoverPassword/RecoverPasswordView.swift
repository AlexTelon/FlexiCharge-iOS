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
    @StateObject var accountAPI = AccountAPI()
    @State var validationText = ""
    
    
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
                        .font(Font.system(size: 36, weight: .bold, design: .default))
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
                .foregroundColor(
                    emailInput == "" ? Color.black :
                        validateEmail(email: emailInput) == "" ? Color.black : Color.primaryRed)
                .onChange(of: emailInput) { newValue in
                    validationText = validateEmail(email: newValue)
                }
            Text("Please provide the email address you used to register.\nWe will send you an email\nwith a link to reset your password")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.top)
                .padding(.horizontal, 2)
                .frame(width: UsefulValues.screenWidth * 0.8)
            Spacer()
            Text("\(validationText)")
                .foregroundColor(.red)
                .padding(.bottom)
            NavigationLink(destination: ChooseNewPassword(email: $emailInput, shouldPopToRootView: $rootIsActive), tag: 1, selection: $selection) {
                // TODO: send email to recover  password
                RegularButton(action: {
                    accountAPI.forgotPassword(email: emailInput) { response in
                        if response == "200"{
                            self.selection = 1
                        }
                        else{
                            validationText = response
                            print("Misslyckades")
                        }
                    }
                }, text: "Send", foregroundColor: Color.white, backgroundColor: validateEmail(email: emailInput) == "" ? Color.primaryGreen : Color.primaryDarkGray)
            }
            .background(RoundedRectangle(cornerRadius: 5))
            .disabled(validateEmail(email: emailInput) != "")
            .padding()
            Spacer()
        }.edgesIgnoringSafeArea(.top)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct RecoverPasswordView_Previews: PreviewProvider {
    @Binding var rootIsActive: Bool
    static var previews: some View {
        RecoverPasswordView(rootIsActive: .constant(false))
    }
}
