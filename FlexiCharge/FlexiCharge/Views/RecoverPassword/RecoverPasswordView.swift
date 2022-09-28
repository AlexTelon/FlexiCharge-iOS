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
                            validateEmail(email: emailInput) == "" ? Color.primaryGreen : Color.primaryRed)
            Text("Please provide the email address you used to register.\nWe will send you an email\nwith a link to reset your password")
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .padding(.top)
                .padding(.horizontal, 2)
                .frame(width: UsefulValues.screenWidth * 0.8)
            Spacer()
            Spacer()
            NavigationLink(destination: ChooseNewPassword(email: $emailInput, shouldPopToRootView: $rootIsActive), tag: 1, selection: $selection) {
                // TODO: send email to recover  password
                RegularButton(action: {
                    accountAPI.forgotPassword(email: emailInput) { response in
                        if response == "200"{
                            self.selection = 1
                        }
                        else{
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
    
    
    
    func validateEmail(email: String) -> String {
        var errorMessage:String = ""
        if email.count < 100 {
            let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
            
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            if !(emailPredicate.evaluate(with: email)){
                errorMessage += "Invalid email address";
                return errorMessage
            }
        }
        return errorMessage
    }
}



struct RecoverPasswordView_Previews: PreviewProvider {
    @Binding var rootIsActive: Bool
    static var previews: some View {
        RecoverPasswordView(rootIsActive: .constant(false))
    }
}
