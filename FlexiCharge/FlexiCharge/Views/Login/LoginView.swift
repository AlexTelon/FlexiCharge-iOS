//
//  LoginView.swift
//  FlexiCharge
//
//  Created by Filip Flodén on 2021-09-13.
//
import SwiftUI

struct LoginView: View {
    let inputHeight: CGFloat = 48
    let inputCornerRadius: CGFloat = 5
    let emailPlaceholder: String = "Email"
    let passwordPlaceholder: String = "Password"
    @StateObject var accountAPI = AccountAPI()
    @EnvironmentObject var accountModel: AccountDataModel
    @State var validationText = ""
    @State var emailValidationText = ""
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var selection: Int? = nil
    @State private var loading: Bool = false
    @State var isActive: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
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
                                        .frame(alignment: .leading)
                                }
                                Spacer()
                                Text("Log In")
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
                            RegularTextField(input: $emailInput, placeholder: "Email", keyboardType: .emailAddress)
                                .padding(.vertical)
                                .foregroundColor(emailInput == "" ? Color.black : validateEmail(email: emailInput) != "" ? Color.primaryRed : Color.black)
                                .onChange(of: emailInput){ _email in
                                    emailValidationText = validateEmail(email: emailInput)
                                    if(_email == ""){
                                        emailValidationText = ""
                                    }
                                }
                            Text("\(emailValidationText)")
                                .foregroundColor(.red)
                                .fixedSize(horizontal: false, vertical: true)
                            SecureTextField(input: $passwordInput, placeholder: "Password", keyboardType: .default)
                                .padding(.vertical)
                            Spacer()
                            Spacer()
                            Text("\(validationText)")
                                .foregroundColor(.red)
                                .padding(.bottom)
                            NavigationLink(destination: ContentView(), tag: 1, selection: $selection) {
                                RegularButton(action: {
                                    self.loading = true
                                    accountAPI.logInUser(email: emailInput, password: passwordInput,  accountDetails: accountModel){ loginStatus in
                                        if(loginStatus.isEmpty){
                                            print("Du loggades in!! :))  \(loginStatus)")
                                            print("AccessToken: \(accountModel.accessToken)")
                                            self.selection = 1
                                        }else{
                                            self.loading = false
                                            validationText = loginStatus
                                        }
                                    }
                                }, text: "Log in", foregroundColor: Color.white, backgroundColor: passwordNotEmpty(input: passwordInput) == "" && validateEmail(email: emailInput) == "" ? Color.primaryGreen : Color.primaryDarkGray)
                            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
                            .disabled(passwordNotEmpty(input: passwordInput) == "" && validateEmail(email: emailInput) != "")
                            Text("Spacer").hidden()
                            NavigationLink(destination: RecoverPasswordView(rootIsActive: $isActive), isActive: self.$isActive) {
                                Text("I forgot my password")
                                    .font(Font.system(size: 13,weight: .bold, design: .default))
                                    .foregroundColor(Color.primaryGreen)
                            }
                            .isDetailLink(false)
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
                .onTapGesture {
                    hideKeyboard()
                }
                withAnimation(.easeInOut) {
                    BasicLoadingScreen(imageName: "flexi-charge-logo-color")
                        .opacity(loading ? 1 : 0)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
