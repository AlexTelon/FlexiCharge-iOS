//
//  RegisterAccount.swift
//  FlexiCharge
//
//  Created by Lucas Strand on 2021-09-13.
//

import SwiftUI

struct RegisterAccountView: View {
    let screenWidth =  UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
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
     
    var body: some View {
        NavigationView{
            VStack() {
                ZStack(){
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
                            .frame(width: screenWidth * 0.8, alignment: .center)
                        Spacer()
                    }.frame(width: screenWidth * 0.95)
                    .offset(y: -screenHeight * 0.03)
                }
                VStack{
                    /*----------Email----------*/
                    ZStack(alignment: .leading){
                        TextField("Email", text: $email)
                        .frame(height: inputHeight)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                    .stroke()
                        )
                        .padding(.top)
                        Text("Email")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(email.count > 0 ? 1 : 0)
                    }
                    /*----------Mobile number----------*/
                    ZStack(alignment: .leading){
                        TextField("Mobile number", text: $mobileNumber)
                        .frame(height: inputHeight)
                        .padding(.horizontal, 8)
                        .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                    .stroke()
                        )
                        .padding(.top)
                        Text("Mobile number")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(mobileNumber.count > 0 ? 1 : 0)
                            .keyboardType(.decimalPad)
                    }
                    /*----------Password----------*/
                    ZStack(alignment: .leading){
                        SecureField ("Password", text: $password)
                            .frame(height: inputHeight)
                            .padding(.horizontal, 8)
                            .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                        .stroke()
                            )
                            .padding(.top)
                        Text("Password")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(password.count > 0 ? 1 : 0)
                    }
                    /*----------Repeat password----------
                    ZStack(alignment: .leading){
                        SecureField("Repeat password", text: $repeatPassword)
                            .frame(height: inputHeight)
                            .padding(.horizontal, 8)
                            .overlay(RoundedRectangle(cornerRadius: inputCornerRadius)
                                        .stroke()
                            )
                            .padding(.top)
                        Text("Repeat password")
                            .foregroundColor(.black)
                            .padding(.horizontal, 5)
                            .background(Color.white)
                            .offset(x: 10, y: -15)
                            .opacity(repeatPassword.count > 0 ? 1 : 0)
                    }*/
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
                        Button(action: {
                            //TO BE DEVELOPED: register user if all validations are fine
                                validationText = validateInputs(email: email, mobileNumber: mobileNumber, password: password, TOSCheckBox: tosCheckBox)
                            
                        }, label: {
                            NavigationLink(destination: LoginView()) {
                                Text("Register")
                                    .frame(width: screenWidth * 0.8, height: inputHeight)
                                    .foregroundColor(.white)
                                    .background(Rectangle().fill(Color(red: 0.47, green: 0.74, blue: 0.46)))
                                    .padding(.bottom)
                            }
                        })
                        
                        HStack{
                            Text("Already have an account?")
                            NavigationLink(destination: LoginView()) {
                                Text("Sign in")
                                    .foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.46))
                            }
                        }
                        Text("Continue as Guest")
                            .foregroundColor(Color(red: 0.47, green: 0.74, blue: 0.46))
                            .padding()
                    }
                    .padding(.bottom)
                }
                .frame(width: screenWidth * 0.8)
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
}

struct RegisterAccount_Previews: PreviewProvider {
    static var previews: some View {
        RegisterAccountView()
    }
}
