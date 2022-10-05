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
                            RegularTextField(input: $emailInput, placeholder: "Username", keyboardType: .default)
                                .padding(.vertical)
                            // Password input field
                            SecureTextField(input: $passwordInput, placeholder: "Password", keyboardType: .default)
                                .padding(.vertical)
                            Spacer()
                            Spacer()
                            Text("\(validationText)")
                                .foregroundColor(.red)
                                .padding(.bottom)
                            NavigationLink(destination: SetupInvoicingView(), tag: 1, selection: $selection) { //ändra tillbaka till contentView()!
                                RegularButton(action: {
                                    validationText = validateInputs(password: passwordInput, username: emailInput)
                                    if(validationText.isEmpty){
                                        self.loading = true
                                        accountAPI.logInUser(email: emailInput, password: passwordInput,  accountDetails: accountDetails){ loginStatus in
                                            if(loginStatus.isEmpty){
                                                print("Du loggades in!! :))  \(loginStatus)")
                                                print("AccessToken: \(accountModel.accessToken)")
                                                print("ISLOGGEDIN: ",accountModel.isLoggedIn)
                                                self.selection = 1
                                            }else{
                                                self.loading = false
                                                validationText = loginStatus
                                            }
                                        }
                                    }
                                }, text: "Log in", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
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
