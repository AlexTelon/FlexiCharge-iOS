//
//  VerifyAccountView.swift
//  FlexiCharge
//
//  Created by david Wennerblom on 2022-09-20.
//

import SwiftUI



struct VerifyAccountView: View {
    
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let emailPlaceholder: String = "Username"
    let verificationCodePlaceholder: String = "Verification code"
    @StateObject var accountAPI = AccountAPI()
    @EnvironmentObject var accountModel: AccountDataModel
    @State var validationText = ""
    @Binding var selection: Int?
    @State private var emailInput: String = ""
    @State private var verificationCodeInput: String = ""
    @State private var loading: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        // Gray design at the top of the screen
                        ZStack {
                            Image("top-tilted-rectangle")
                                .resizable()
                                .scaledToFit()
                            HStack {
                                Spacer()
                                Text("Verify account")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 44, weight: .bold, design: .default))
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                Spacer()
                                Image("menu-arrow")
                                    .hidden()
                            }
                            .frame(width: UsefulValues.screenWidth * 0.95, alignment: .center)
                            .offset(y: -UsefulValues.screenHeight * 0.03)
                        }
                        // Login "form"
                        VStack {
                            // Email input field
                            RegularTextField(input: $emailInput, placeholder: emailPlaceholder, keyboardType: .default)
                                .padding(.vertical)
                            // Password input field
                            RegularTextField(input: $verificationCodeInput, placeholder: verificationCodePlaceholder, keyboardType: .default)
                                .padding(.vertical)
                            Spacer()
                            Spacer()
                            Text("\(validationText)")
                                .foregroundColor(.red)
                                .padding(.bottom)
                                .fixedSize(horizontal: false, vertical: true)
                                RegularButton(action: {
                                    validationText = validateInputs(username: emailInput, validationCode: verificationCodeInput)

                                    if(validationText.isEmpty){
                                        self.loading = true
                                        accountAPI.verifyAccount(email: emailInput, verificationCode: verificationCodeInput, accountDetails: accountModel){ verifyStatus in
                                            if(verifyStatus.isEmpty){
                                                self.loading = false
                                                print("Verification successful!")
                                                self.selection = 2
                                            }else{
                                                self.loading = false
                                                validationText = verifyStatus
                                            }
                                        }
                                    }
                                    
                                }, text: "Verify account", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                            Text("Spacer").hidden()
                            Spacer()
                        }
                        .frame(width: UsefulValues.screenWidth * 0.8)
                    }.frame(height: UsefulValues.screenHeight)
                }
                .edgesIgnoringSafeArea(.top)
                .frame(minHeight: 0, maxHeight: .infinity)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .navigationBarHidden(true)
                withAnimation(.easeInOut) {
                    BasicLoadingScreen(imageName: "flexi-charge-logo-color")
                        .opacity(loading ? 1 : 0)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

//struct VerifyAccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerifyAccountView(rootIsActive: Binding<Bool> test: false)
//    }
//}




//Button(action: {
//    self.presentationMode.wrappedValue.dismiss()
//}) {
//    Image("menu-arrow").rotationEffect(.degrees(90))
//        .aspectRatio(contentMode: .fit)
//        .foregroundColor(.white)
//        .frame(alignment: .leading)
//}
