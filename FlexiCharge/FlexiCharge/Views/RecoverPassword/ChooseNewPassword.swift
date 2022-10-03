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
    @State var selection: Int? = nil
    
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
                    .foregroundColor(
                            password == "" ? Color.black : validatePassword(password: password) ? Color.primaryGreen : Color.primaryRed
                    )
                Spacer()
                RegularTextField(input: $verificationCode, placeholder: "Verification code", keyboardType: .default)
                    .foregroundColor(
                            verificationCode == "" ? Color.black : validateVerificationCode(verificationCode: verificationCode) ? Color.primaryGreen : Color.primaryRed
                    )
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
                    }, text: "Confirm password", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                }
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
    
    func validatePassword(password: String)->Bool{
        
        var validPassword: Bool = false
        
        let specialCharacters = CharacterSet.punctuationCharacters
        let upperCaseCharacters = CharacterSet.uppercaseLetters
        let lowerCaseCharacters = CharacterSet.lowercaseLetters
        
        let hasSpecialCharacter = password.description.rangeOfCharacter(from: specialCharacters)
        let hasUppercaseCharacter = password.description.rangeOfCharacter(from: upperCaseCharacters)
        let hasLowerCasecharacters = password.description.rangeOfCharacter(from: lowerCaseCharacters)
        
        
        //Checks for special characters, uppercase characters and lowercase characters
        validPassword = hasSpecialCharacter != nil ? true : false
        validPassword = hasUppercaseCharacter != nil ? true : false
        validPassword = hasLowerCasecharacters != nil ? true : false
        
        //Checks if password is atleast 8 characters
        if password.count <= 8 /*|| repeavalidPasswordtedPassword.count < 7*/ {
            validPassword = false
        }
        return validPassword
    }
    
    func validateVerificationCode(verificationCode: String)->Bool{
        
        var validVerificationCode: Bool = false
        
        //Checks if code isNumber
        var isNumber: Bool {
            CharacterSet(charactersIn: verificationCode).isSubset(of: CharacterSet.decimalDigits)
        }
        
        //Checks if password is atleast 8 characters
        if verificationCode.count <= 5  && isNumber {
            validVerificationCode = false
        }
        return validVerificationCode
    }
}
