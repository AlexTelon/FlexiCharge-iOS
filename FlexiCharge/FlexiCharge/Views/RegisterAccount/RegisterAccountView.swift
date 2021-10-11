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
    @State private var isEditing = false
    @State private var inputHeight: CGFloat = 48
    @State private var inputCornerRadius: CGFloat = 5
    @State private var tosCheckBox: Bool = false
    @State private var validEmail: Bool = false
    @State private var validationText: String = ""
    @State private var selection: Int? = nil
    
    var body: some View {
        NavigationView{
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
                        /*----------Mobile number----------*/
                        RegularTextField(input: $mobileNumber, placeholder: "Mobile number", keyboardType: .numberPad)
                            .padding(.top)
                        /*----------Password----------*/
                        SecureTextField(input: $password, placeholder: "Password", keyboardType: .default)
                            .padding(.top)
                        /*----------Repeat password----------*/
                        /* SecureTextField(input: $repeatPassword, placeholder: "Repeat password", keyboardType: .default)
                         .padding(.top) */
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
                            Text(validationText)
                                .foregroundColor(.red)
                                .padding(.bottom)
                            //TO BE DEVELOPED: register user if all validations are fine
                            NavigationLink(destination: LoginView(), tag: 1, selection: $selection) {
                                RegularButton(action: {
                                    //TO BE DEVELOPED: register user if all validations are fine
                                    validationText = validateInputs(email: email, mobileNumber: mobileNumber, password: password, TOSCheckBox: tosCheckBox)
                                    self.selection = 1
                                }, text: "Register", foregroundColor: Color.white, backgroundColor: Color.primaryGreen)
                            }.background(RoundedRectangle(cornerRadius: 5).fill(Color.primaryGreen))
                            Text("Spacer").hidden()
                            HStack{
                                Text("Already have an account?")
                                NavigationLink(destination: LoginView()) {
                                    Text("Sign in")
                                        .foregroundColor(Color.primaryGreen)
                                }
                            }
                            NavigationLink(destination: ContentView()) {
                                Text("Continue as Guest")
                                    .foregroundColor(Color.primaryGreen)
                                    .padding()
                            }
                        }
                        Spacer()
                    }
                    .frame(width: UsefulValues.screenWidth * 0.8)
                }.frame(height: UsefulValues.screenHeight)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .onTapGesture {
                hideKeyboard()
            }
        }
        .autocapitalization(.none)
        .disableAutocorrection(true)
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
