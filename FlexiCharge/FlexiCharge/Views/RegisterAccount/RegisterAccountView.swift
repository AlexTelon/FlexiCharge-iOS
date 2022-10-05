//
//  RegisterAccount.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-13.
//

import SwiftUI

struct RegisterAccountView: View {
    @State private var email: String = ""
    @State private var mobileNumber = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var username: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var isEditing = false
    @State private var inputHeight: CGFloat = 48
    @State private var inputCornerRadius: CGFloat = 5
    @State private var tosCheckBox: Bool = false
    @State private var validEmail: Bool = false
    @State private var validPassword: Bool = false
    @State private var emailValidationText: String = ""
    @State private var passwordValidationText: String = ""
    @State private var validationText: String = ""
    @State private var registerValidationText: String = ""
    @State var selection: Int? = nil
    @State private var loading: Bool = false
    @State var isActive: Bool = false
    
    
    @StateObject var accountAPI = AccountAPI()
    
    var body: some View {
        NavigationView{
            ZStack {
                ScrollView {
                    VStack {
                        ZStack {
                            Image("topShapeRegister")
                                .resizable()
                                .scaledToFit()
                            HStack {
                                Spacer()
                                Text("Register")
                                    .foregroundColor(.white)
                                    .font(Font.system(size: 40, weight: .bold, design: .default))
                                    .scaledToFill()
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .frame(width: UsefulValues.screenWidth * 0.8, alignment: .center)
                                Spacer()
                            }
                            .offset(y: -UsefulValues.screenHeight * 0.03)
                        }
                        VStack{
                            /*----------Email----------*/
                            RegularTextField(input: $email, placeholder: "Email", keyboardType: .emailAddress)
                                .padding(.top)
                                .foregroundColor(email == "" ? Color.black : validateEmail(email: email) != "" ? Color.primaryRed : Color.primaryGreen)
                                .onChange(of: email){ _email in
                                    emailValidationText = validateEmail(email: _email)
                                    if(_email == ""){
                                        emailValidationText = ""
                                    }
                                }
                            Text("\(emailValidationText)")
                                .foregroundColor(.red)
                                .padding(.bottom)
                                .fixedSize(horizontal: false, vertical: true)
                            /*----------Password----------*/
                            SecureTextField(input: $password, placeholder: "Password", keyboardType: .default)
                                .padding(.top)
                                .foregroundColor(password == "" ? Color.black : validatePassword(password: password) != "" ? Color.primaryRed : Color.primaryGreen)
                                .onChange(of: password){ _password in
                                    passwordValidationText = validatePassword(password: _password)
                                    if(_password == ""){
                                        passwordValidationText = ""
                                    }
                                }
                            Text("\(passwordValidationText)")
                                .foregroundColor(.red)
                                .padding(.bottom)
                                .fixedSize(horizontal: false, vertical: true)
                            /*----------Repeat password----------*/
                            /*SecureTextField(input: $repeatPassword, placeholder: "Repeat password", keyboardType: .default)
                             .padding(.top)*/
                            /*----------Checkbox----------*/
                            HStack{
                                Button(action: {tosCheckBox.toggle()}, label: {
                                    Image(systemName: tosCheckBox ? "checkmark" : "")
                                        .frame(width: 30, height: 30)
                                        .overlay(Rectangle()
                                                    .stroke()
                                        )
                                        .foregroundColor(.black)
                                })
                                Text("I agree to the terms and conditions")
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding(.top)
                            Spacer()
                            /*----------Register button and the following text----------*/
                            VStack{
                                Text("\(validationText)")
                                    .foregroundColor(.red)
                                    .padding(.bottom)
                                    .fixedSize(horizontal: false, vertical: true)
                                NavigationLink(destination: LoginView(), tag: 2, selection: $selection){ EmptyView() }
                                NavigationLink(destination: VerifyAccountView(selection: $selection), tag: 1, selection: $selection){
                                    RegularButton(action: {
                                        validationText = validateInputs(email: email, password: password, TOSCheckBox: tosCheckBox)
                                        
                                        if(validationText.isEmpty){ accountAPI.registerAccount(email: email, password: password){ validationErrors in
                                            
                                            print("validation errors in registerView: \(validationErrors)")
                                            
                                            if(validationErrors.isEmpty){
                                                username = ""
                                                password = ""
                                                email = ""
                                                firstName = ""
                                                lastName = ""
                                                validationText = ""
                                                self.selection = 1
                                            }else{
                                                validationText = validationErrors
                                            }
                                        }
                                                
                                        }
                                    }, text: "Register", foregroundColor: Color.white, backgroundColor: validatePassword(password: password) != "" ? Color.primaryDarkGray : Color.primaryGreen)
                                }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
                                    .disabled(validatePassword(password: password) != "" && validateEmail(email: email) != "")
                                
                                
                                Text("Spacer").hidden()
                                HStack{
                                    Text("Already have an account?")
                                    NavigationLink(destination: LoginView()) {
                                        Text("Sign in")
                                            .foregroundColor(Color.primaryGreen)
                                    }
                                }
                                NavigationLink(destination: ContentView(), tag: 3, selection: $selection) {
                                    Button(action: {
                                        self.loading = true

                                        self.selection = 2
                                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                                        UserDefaults.standard.synchronize()

                                        self.selection = 3
                                        
                                    }, label: {
                                        Text("Continue as Guest")
                                            .foregroundColor(Color.primaryGreen)
                                            .padding()
                                    })
                                }
                            }
                            Spacer()
                        }.frame(width: UsefulValues.screenWidth * 0.8)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarHidden(true)
                .onTapGesture {
                    hideKeyboard()
                }
                withAnimation(.easeInOut) {
                    BasicLoadingScreen(imageName: "flexi-charge-logo-color")
                        .opacity(loading ? 1 : 0)
                }
            }
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        .onAppear(perform: setLoggedInToFalse)
        .navigationBarBackButtonHidden(true)
    }
    
    func setLoggedInToFalse() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct RegisterAccount_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
